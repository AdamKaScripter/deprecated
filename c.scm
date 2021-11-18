(define-module (c)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix utils)
  #:use-module (guix packages)
  #:use-module (guix download)
  #:use-module (guix git-download)
  #:use-module (guix build-system cmake)
  #:use-module (guix build-system gnu)
  #:use-module (guix build-system trivial)
  #:use-module (gnu packages)
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
                    (commit (string-append "v" version))))
              (file-name (git-file-name name version))
              (sha256
               (base32
                "0anfg24whrmjgfh24akc6i78gbm4fg8rq55nyni4qahp8adysxq3"))))
    (build-system cmake-build-system)
    (native-inputs `(("libpng" ,libpng)))
    ;; (arguments
    ;;  '(#:configure-flags
    ;;    '("-DBUILD_SHARED_LIBS=ON")))
    (synopsis "")
    (description
     "")
    (home-page "")
    (license #f)))
