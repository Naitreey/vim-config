"PVerb verbatim
syn region innerBrace		start=+\%(\\PVerb\)\@<!{+		end=+}+ transparent contains=innerBrace
syn region texZone		start="\\PVerb{"			end="}\|%stopzone\>" contains=innerBrace
"listings package
syn region texZone		start="\\begin{lstlisting}"		end="\\end{lstlisting}\|%stopzone\>"
