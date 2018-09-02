" highlight MathJax LaTeX extensions
syn match inline_math '\$[^$].\{-}\$'
syn region block_math start=/\$\$/ end=/\$\$/
syn cluster markdownInline add=inline_math,block_math
syn cluster markdownBlock add=inline_math,block_math
hi link inline_math Statement
hi link block_math Statement
