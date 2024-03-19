;; bake syntax highlighting
(load-file "~/.emacs.d/bake-mode.el")

(defun bake-get-moduledir ()
  (interactive)
  (setq basedir default-directory)
  (while
      (and
       (not (file-exists-p (file-name-concat basedir "Project.meta")))
       (not (string-equal basedir projectile-project-src-dir)))
    ;; (print basedir)
    (setq basedir (directory-file-name (file-name-directory basedir))))
  basedir)

(defun bake-build-unit-tests (module)
  (interactive "sModule: ")
  (let ((default-directory projectile-project-root))
    (shell-command (format "bake -m %s -b UnitTestBase --adapt gcc -a black -j8 --compilation-db" module))
    (switch-to-buffer "*Shell Command Output*")
    (display-ansi-colors)
    (end-of-buffer)
    (switch-to-prev-buffer)))

(defun bake-run-current-tests ()
  (interactive)
  (let ((moduledir (bake-get-moduledir))
        (modulename (file-name-nondirectory moduledir))
        (test-executable (file-name-concat moduledir "build" "UnitTestBase" modulename)))
    (shell-command test-executable)
    (split-window-below)
    (other-window 1)
    (switch-to-buffer "*Shell Command Output*")
    (end-of-buffer)
    (other-window -1)))

;; TODO: pick a test interactively
(defun bake-gdb-current-tests ()
  (interactive)
  ;; find a directory with project.meta
  (setq moduledir (bake-get-moduledir)
        modulename (file-name-nondirectory moduledir)
        test-executable (file-name-concat moduledir "build" "UnitTestBase" modulename))
  ;; (unless (file-exists-p test-executable)
    ;; (bake-build-unit-tests moduledir))
  (gdb (format "gdb -i=mi --args %s" test-executable)))

(defun get-mock-class (file-name)
  (interactive "sFilename: ")
  (let ((rel-file-name (file-name-nondirectory file-name)))
    (string-remove-prefix
     "I"
     (concat (substring rel-file-name 0 (string-search "." rel-file-name)) "Mock"))))

(defun bake-get-mock-header (file-name mock-path)
  (let ((moduledir (bake-get-moduledir)))
    (file-name-concat moduledir
                      mock-path
                      (file-relative-name (file-name-directory file-name) moduledir)
                      (concat (get-mock-class file-name) ".h"))))

(defun bake-get-mock-source (file-name mock-path)
  (let ((moduledir (bake-get-moduledir)))
    (file-name-concat moduledir
                      mock-path
                      "src"
                      (file-relative-name
                       (file-name-directory file-name)
                       (file-name-concat moduledir "include"))
                      (concat (get-mock-class file-name) ".cpp"))))

(defun cxx-genmock-interface (input-file output-header)
  (interactive "sFilename: \nsOutput header: ")
  (shell-command (format "genmock --mocktype=interface --outh=%s %s" output-header input-file)))

(defun cxx-genmock-singleton (input-file output-header output-source)
  (interactive "sFilename: \nsOutput header: ")
  (shell-command (format "genmock --mocktype=singleton --outh=%s --outsrc=%s %s" output-header output-source input-file)))

(defun bake-mock-current-interface (mock-path)
  (interactive "sMock path: ")
  (cxx-genmock-interface
   (buffer-file-name)
   (bake-get-mock-header (buffer-file-name) mock-path)))

(defun bake-mock-current-singleton (mock-path)
  (interactive "sMock path: ")
  (cxx-genmock-singleton
   (buffer-file-name)
   (bake-get-mock-header (buffer-file-name) mock-path)
   (bake-get-mock-source (buffer-file-name) mock-path)))
