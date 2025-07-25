;; extends

; Template section (HTML)
((template_element 
   (start_tag) @_tag
   (text) @injection.content)
 (#set! injection.language "html")
 (#set! injection.include-children)
 (#set! bo.commentstring "<!-- %s -->"))

; Script section (JavaScript/TypeScript)
((script_element
   (start_tag 
     (attribute
       (attribute_name) @_name
       (quoted_attribute_value (attribute_value) @_lang)))
   (raw_text) @injection.content)
 (#eq? @_name "lang")
 (#any-of? @_lang "ts" "typescript")
 (#set! injection.language "typescript")
 (#set! bo.commentstring "// %s"))

((script_element
   (raw_text) @injection.content)
 (#set! injection.language "javascript") 
 (#set! bo.commentstring "// %s"))

; Style section (CSS/SCSS/Less)
((style_element
   (start_tag
     (attribute
       (attribute_name) @_name
       (quoted_attribute_value (attribute_value) @_lang)))
   (raw_text) @injection.content)
 (#eq? @_name "lang")
 (#any-of? @_lang "scss" "sass")
 (#set! injection.language "scss")
 (#set! bo.commentstring "/* %s */"))

((style_element
   (start_tag
     (attribute
       (attribute_name) @_name  
       (quoted_attribute_value (attribute_value) @_lang)))
   (raw_text) @injection.content)
 (#eq? @_name "lang")
 (#eq? @_lang "less")
 (#set! injection.language "less")
 (#set! bo.commentstring "/* %s */"))

((style_element
   (raw_text) @injection.content)
 (#set! injection.language "css")
 (#set! bo.commentstring "/* %s */"))
