;; extends

; Set default commentstring for the entire Vue file
((document) @_doc
 (#set! bo.commentstring "<!-- %s -->"))

; Override commentstring for script sections
((script_element) @_script
 (#set! bo.commentstring "// %s"))

; Override commentstring for style sections  
((style_element) @_style
 (#set! bo.commentstring "/* %s */"))
