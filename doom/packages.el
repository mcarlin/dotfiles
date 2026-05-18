;; -*- no-byte-compile: t; -*-
;;; $DOOMDIR/packages.el

;; Diagram packages
(package! ob-mermaid)
(package! mermaid-mode)
(package! plantuml-mode)
(package! org-excalidraw
  :recipe (:host github :repo "4honor/org-excalidraw"))
(package! howm)
(package! gptel :recipe (:nonrecursive t))

(package! request)
(package! dash)
(package! jiralib2
  :recipe (:local-repo "local-packages/jiralib2"))
(package! org-ql)
(package! org-transclusion)
(package! org-super-agenda)

(package! gptel-tool-library
  :recipe (:host github :repo "aard-fi/gptel-tool-library"))
