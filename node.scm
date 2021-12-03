(define-module (node)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module ((guix build utils) #:select (alist-replace))
  #:use-module (guix packages)
  #:use-module (guix derivations)
  #:use-module (guix download)
  #:use-module (guix git-download)
  #:use-module (guix utils)
  #:use-module (guix build-system gnu)
  #:use-module (guix build-system node)
  #:use-module (gnu packages)
  #:use-module (gnu packages adns)
  #:use-module (gnu packages base)
  #:use-module (gnu packages bash)
  #:use-module (gnu packages compression)
  #:use-module (gnu packages gcc)
  #:use-module (gnu packages icu4c)
  #:use-module (gnu packages libevent)
  #:use-module (gnu packages linux)
  #:use-module (gnu packages node-xyz)
  #:use-module (gnu packages perl)
  #:use-module (gnu packages pkg-config)
  #:use-module (gnu packages python)
  #:use-module (gnu packages tls)
  #:use-module (gnu packages web)
  #:use-module (ice-9 match)
  #:use-module (srfi srfi-26))

(define-public my-node-lts
  (package
    (inherit node)
    (version "14.18.1")
    (source (origin
              (method url-fetch)
              (uri (string-append "https://nodejs.org/dist/v" version
                                  "/node-v" version ".tar.xz"))
              (sha256
               (base32
                "1vc9rypkgr5i5y946jnyr9jjpydxvm74p1s17rg2zayzvlddg89z"))
              (modules '((guix build utils)))
              (snippet
               `(begin
                  ;; Remove bundled software, where possible
                  (for-each delete-file-recursively
                            '("deps/cares"
                              "deps/icu-small"
                              "deps/nghttp2"
                              "deps/openssl"
                              "deps/zlib"))
                  (substitute* "Makefile"
                    ;; Remove references to bundled software.
                    (("deps/uv/uv.gyp") "")
                    (("deps/zlib/zlib.gyp") ""))
                  #t))))
    (arguments
     (substitute-keyword-arguments (package-arguments node)
       ((#:configure-flags configure-flags)
        ''("--shared-cares"
           "--shared-libuv"
           "--shared-nghttp2"
           "--shared-openssl"
           "--shared-zlib"
           "--shared-brotli"
           "--with-intl=system-icu"))
       ((#:phases phases)
        `(modify-phases ,phases
           (replace 'set-bootstrap-host-rpath
             (lambda* (#:key native-inputs inputs #:allow-other-keys)
               (let* ((inputs        (or native-inputs inputs))
                      (c-ares        (assoc-ref inputs "c-ares"))
                      (brotli        (assoc-ref inputs "brotli"))
                      (icu4c         (assoc-ref inputs "icu4c"))
                      (nghttp2       (assoc-ref inputs "nghttp2"))
                      (openssl       (assoc-ref inputs "openssl"))
                      (libuv         (assoc-ref inputs "libuv"))
                      (zlib          (assoc-ref inputs "zlib"))
                      (host-binaries '("torque"
                                       "bytecode_builtins_list_generator"
                                       "gen-regexp-special-case"
                                       "node_mksnapshot"
                                       "mksnapshot")))
                 (substitute* '("node.gyp" "tools/v8_gypfiles/v8.gyp")
                   (((string-append "'target_name': '("
                                    (string-join host-binaries "|")
                                    ")',")
                      target)
                    (string-append target
                                   "'ldflags': ['-Wl,-rpath="
                                   c-ares "/lib:"
                                   brotli "/lib:"
                                   icu4c "/lib:"
                                   nghttp2 "/lib:"
                                   openssl "/lib:"
                                   libuv "/lib:"
                                   zlib "/lib"
                                   "'],"))))))
           (replace 'configure
             ;; Node's configure script is actually a python script, so we can't
             ;; run it with bash.
             (lambda* (#:key outputs (configure-flags '()) native-inputs inputs
                       #:allow-other-keys)
               (let* ((prefix (assoc-ref outputs "out"))
                      (xflags ,(if (%current-target-system)
                                   `'("--cross-compiling"
                                     ,(string-append
                                       "--dest-cpu="
                                       (match (%current-target-system)
                                         ((? (cut string-prefix? "arm" <>))
                                          "arm")
                                         ((? (cut string-prefix? "aarch64" <>))
                                          "arm64")
                                         ((? (cut string-prefix? "i686" <>))
                                          "ia32")
                                         ((? (cut string-prefix? "x86_64" <>))
                                          "x64")
                                         ((? (cut string-prefix? "powerpc64" <>))
                                          "ppc64")
                                         (_ "unsupported"))))
                                   ''()))
                      (flags (cons
                               (string-append "--prefix=" prefix)
                               (append xflags configure-flags))))
                 (format #t "build directory: ~s~%" (getcwd))
                 (format #t "configure flags: ~s~%" flags)
                 ;; Node's configure script expects the CC environment variable to
                 ;; be set.
                 (setenv "CC_host" "gcc")
                 (setenv "CXX_host" "g++")
                 (setenv "CC" ,(cc-for-target))
                 (setenv "CXX" ,(cxx-for-target))
                 (setenv "PKG_CONFIG" ,(pkg-config-for-target))
                 (apply invoke
                        (string-append (assoc-ref (or native-inputs inputs)
                                                  "python")
                                       "/bin/python3")
                        "configure" flags))))
           (replace 'patch-files
             (lambda* (#:key inputs #:allow-other-keys)
               ;; Fix hardcoded /bin/sh references.
               (substitute* '("lib/child_process.js"
                              "lib/internal/v8_prof_polyfill.js"
                              "test/parallel/test-child-process-spawnsync-shell.js"
                              "test/parallel/test-fs-write-sigxfsz.js"
                              "test/parallel/test-stdio-closed.js"
                              "test/sequential/test-child-process-emfile.js")
                 (("'/bin/sh'")
                  (string-append "'" (assoc-ref inputs "bash") "/bin/sh'")))

               ;; Fix hardcoded /usr/bin/env references.
               (substitute* '("test/parallel/test-child-process-default-options.js"
                              "test/parallel/test-child-process-env.js"
                              "test/parallel/test-child-process-exec-env.js")
                 (("'/usr/bin/env'")
                  (string-append "'" (assoc-ref inputs "coreutils")
                                 "/bin/env'")))

               ;; FIXME: These tests fail in the build container, but they don't
               ;; seem to be indicative of real problems in practice.
               (for-each delete-file
                         '("test/parallel/test-cluster-master-error.js"
                           "test/parallel/test-cluster-master-kill.js"))

               ;; These require a DNS resolver.
               (for-each delete-file
                         '("test/parallel/test-dns.js"
                           "test/parallel/test-dns-lookupService-promises.js"))

               ;; These tests require networking.
               (delete-file "test/parallel/test-https-agent-unref-socket.js")

               ;; FIXME: This test fails randomly:
               ;; https://github.com/nodejs/node/issues/31213
               (delete-file "test/parallel/test-net-listen-after-destroying-stdin.js")

               ;; FIXME: These tests fail on armhf-linux:
               ;; https://github.com/nodejs/node/issues/31970
               ,@(if (target-arm32?)
                     '((for-each delete-file
                                 '("test/parallel/test-zlib.js"
                                   "test/parallel/test-zlib-brotli.js"
                                   "test/parallel/test-zlib-brotli-flush.js"
                                   "test/parallel/test-zlib-brotli-from-brotli.js"
                                   "test/parallel/test-zlib-brotli-from-string.js"
                                   "test/parallel/test-zlib-convenience-methods.js"
                                   "test/parallel/test-zlib-random-byte-pipes.js"
                                   "test/parallel/test-zlib-write-after-flush.js")))
                     '())

               ;; These tests have an expiry date: they depend on the validity of
               ;; TLS certificates that are bundled with the source.  We want this
               ;; package to be reproducible forever, so remove those.
               ;; TODO: Regenerate certs instead.
               (for-each delete-file
                         '("test/parallel/test-tls-passphrase.js"
                           "test/parallel/test-tls-server-verify.js"))

               ;; Replace pre-generated llhttp sources
               (let ((llhttp (assoc-ref inputs "llhttp")))
                 (copy-file (string-append llhttp "/src/llhttp.c")
                            "deps/llhttp/src/llhttp.c")
                 (copy-file (string-append llhttp "/src/api.c")
                            "deps/llhttp/src/api.c")
                 (copy-file (string-append llhttp "/src/http.c")
                            "deps/llhttp/src/http.c")
                 (copy-file (string-append llhttp "/include/llhttp.h")
                            "deps/llhttp/include/llhttp.h"))))))))
    (native-inputs
     `(;; Runtime dependencies for binaries used as a bootstrap.
       ("c-ares" ,c-ares-for-node)
       ("brotli" ,brotli)
       ("icu4c" ,icu4c-67)
       ("libuv" ,libuv-for-node)
       ("nghttp2" ,nghttp2 "lib")
       ("openssl" ,openssl)
       ("zlib" ,zlib)
       ;; Regular build-time dependencies.
       ("perl" ,perl)
       ("pkg-config" ,pkg-config)
       ("procps" ,procps)
       ("python" ,python)
       ("util-linux" ,util-linux)))
    (inputs
     `(("bash" ,bash)
       ("coreutils" ,coreutils)
       ("c-ares" ,c-ares-for-node)
       ("icu4c" ,icu4c-67)
       ("libuv" ,libuv-for-node)
       ("llhttp" ,llhttp-bootstrap)
       ("brotli" ,brotli)
       ("nghttp2" ,nghttp2 "lib")
       ("openssl" ,openssl)
       ("zlib" ,zlib)))))
