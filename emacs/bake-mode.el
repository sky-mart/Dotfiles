;;; bake-mode.el --- Mode for bakes Project.meta files.
;; Copyright 2016 christian.koestlin@gmail.com
;;; Commentary:
;; Simple mode for the bake toolkit.  (http://esrlabs.github.io/bake/)
;;; Code:

(require 's)

(defgroup bake-mode nil
  "Mode for bake's Project.meta files."
  :group 'bake-mode)

(defcustom bake-mode/indent 4
  "Number of space for one indent.

Emacs adds spaces/tabs according to your settings."
  :type 'integer
  :tag "Indent"
  :safe t)

(defcustom bake-mode/format-command "bake-format"
  "Bake-format for formatting."
  :type 'string
  :tag "Indent"
  :safe t)

(defun bake-mode/indent-function ()
  "Indent a line for a bake file."
  (interactive)
  (save-excursion
    (beginning-of-line)
    (let* ((p1 (line-beginning-position))
           (p2 (line-end-position))
           (l (s-trim (buffer-substring-no-properties p1 p2)))
           (end-of-block (string-match "}" l))
           (temporary-indent (car (syntax-ppss)))
           (indent (if end-of-block (1- temporary-indent) temporary-indent)))
      ;;(message (format "syntax-ppss: temporary-indent: %s\nl: %s\nend-of-block: %s\nindent: %s" indent l end-of-block indent))
      (indent-line-to (* bake-mode/indent indent)))))

(define-generic-mode
    'bake-mode
  '("#"
    )
  '(
    "Project"
    "Description"
    "RequiredBakeVersion"
    "Responsible"
    "Person"
    "ExecutableConfig"
    "LibraryConfig"
    "CustomConfig"
    "IncludeDir"
    "Set"
    "Dependency"
    "ExternalLibrary"
    "UserLibrary"
    "ExternalLibrarySearchPath"
    "PreSteps"
    "Makefile"
    "Flags"
    "CommandLine"
    "PostSteps"
    "StartupSteps"
    "ExitSteps"
    "DefaultToolchain"
    "Compiler"
    "ASM"
    "CPP"
    "C"
    "Define"
    "Archiver"
    "Linker"
    "LibPrefixFlags"
    "LibPostfixFlags"
    "LintPolicy"
    "Docu"
    "Prebuild"
    "Except"
    "Files"
    "ExcludeFiles"
    "ArtifactName"
    "LinkerScript"
    "MapFile"
    )
  '(("=" . 'font-lock-operator)
    ("+" . 'font-lock-operator)
    (";" . 'font-lock-builtin)
    ;; options
    ("add" . 'font-lock-constant-face)
    ("back" . 'font-lock-constant-face)
    ("cmd" . 'font-lock-constant-face)
    ("command" . 'font-lock-constant-face)
    ("config" . 'font-lock-constant-face)
    ("default" . 'font-lock-constant-face)
    ("eclipseOrder" . 'font-lock-constant-face)
    ("email" . 'font-lock-constant-face)
    ("env" . 'font-lock-constant-face)
    ("extends" . 'font-lock-constant-face)
    ("false" . 'font-lock-constant-face)
    ("filter" . 'font-lock-constant-face)
    ("filter" . 'font-lock-constant-face)
    ("front" . 'font-lock-constant-face)
    ("inherit" . 'font-lock-constant-face)
    ("inject" . 'font-lock-constant-face)
    ("lib" . 'font-lock-constant-face)
    ("maximum" . 'font-lock-constant-face)
    ("minimum" . 'font-lock-constant-face)
    ("off" . 'font-lock-constant-face)
    ("on" . 'font-lock-constant-face)
    ("outputDir" . 'font-lock-constant-face)
    ("pathTo" . 'font-lock-constant-face)
    ("remove" . 'font-lock-constant-face)
    ("search" . 'font-lock-constant-face)
    ("target" . 'font-lock-constant-face)
    ("true" . 'font-lock-constant-face)
    ("validExitCodes" . 'font-lock-constant-face)
    ("value" . 'font-lock-constant-face)

    ;; the rest
    ("[A-Za-z0-9]*" . 'font-lock-variable-name-face)
    )
  '("Project.meta"
    )
  (list
   (lambda() (set (make-local-variable 'indent-line-function) #'bake-mode/indent-function))
   )
  "A mode for bake's Project.meta files"
  )

(defun bake-mode/format ()
  "Format current buffer with bake-format."
  (interactive)
  (shell-command-on-region
   (point-min) (point-max)
   (format "%s - - " (expand-file-name bake-mode/format-command))
   (current-buffer)
   t
   "*bake-mode/Error Buffer*"))

(provide 'bake-mode)
;;; bake-mode.el ends here
