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
                "17iknzqs6dl0ixajplc47ylkyynwpi3x2dxh56wa8ylhgy53d09x"))))
    (build-system cmake-build-system)
    ;; (arguments
    ;;  '(#:configure-flags
    ;;    '("-DBUILD_SHARED_LIBS=ON")))
    (synopsis "")
    (description
     "")
    (home-page "")
    (license #f)))
