(define-module (pkgs c)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix utils)
  #:use-module (guix packages)
  #:use-module (guix download)
  #:use-module (guix git-download)
  #:use-module (guix build-system cmake)
  #:use-module (guix build-system gnu)
  #:use-module (guix build-system trivial)
  #:use-module (gnu packages)
  #:use-module (gnu packages sdl)
  #:use-module (gnu packages image)
  #:use-module (gnu packages bash)
  #:use-module (gnu packages bootstrap)
  #:use-module (gnu packages bison)
  #:use-module (gnu packages check)
  #:use-module (gnu packages flex)
  #:use-module (gnu packages perl)
  #:use-module (gnu packages texinfo)
  #:use-module (gnu packages guile)
  #:use-module (gnu packages lua)
  #:use-module (gnu packages multiprecision)
  #:use-module (gnu packages pcre)
  #:use-module (gnu packages python)
  #:use-module (gnu packages python-xyz)
  #:use-module (gnu packages autotools)
  #:use-module (gnu packages gettext)
  #:use-module (gnu packages pkg-config)
  #:use-module (gnu packages tls)
  #:use-module (gnu packages xml))

(define-public tic-80
  (package
    (name "tic-80")
    (version "0.90.1723")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/nesbox/TIC-80")
                    (commit (string-append "v" version))
                    (recursive? #t)))
              (file-name (git-file-name name version))
              (sha256
               (base32
                "1kmk5a76fs9krqkv4cc7wv6vlg0zlszz0yf2dlymwzmyn5hb758y"))))
    (build-system cmake-build-system)
    (arguments
     `(;; #:modules ((guix build python-build-system)
       ;;            (guix build utils)
       ;;            (ice-9 ftw))
       #:phases
       (modify-phases %standard-phases
         (add-after 'unpack setenv
           (lambda* (#:key inputs outputs tests? #:allow-other-keys)
             (setenv "HOME" "/tmp"))))))
    (synopsis "")
    (description
     "")
    (home-page "")
    (license #f)))

(define-public diff2dates
  (let ((home-page "https://github.com/AdamKaScripter/deprecated")
        (commit "32773110098490792e11c7781c9a422cee5fb3ed")
        (revision "1"))
    (package
      (name "diff2dates")
      (version (git-version "1.0.0" revision commit))
      (source (origin
                (method git-fetch)
                (uri (git-reference
                      (url home-page)
                      (commit commit)
                      (recursive? #t)))
                (file-name (git-file-name name version))
                (sha256
                 (base32
                  "1rcj0g4h0nfmqdid5mx0kviwqapd6d43kx3swvwx3cpdchw1rk42"))))
      (build-system gnu-build-system)
      (arguments
       `(#:phases
         (modify-phases %standard-phases
           (add-after 'unpack 'change-directory
             ;; diff2dates directory is not in root of the source.
             (lambda _
               (chdir "stuff"))))))
      (synopsis "")
      (description
       "")
      (home-page home-page)
      (license license:gpl3+))))
