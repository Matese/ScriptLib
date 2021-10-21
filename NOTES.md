# Warning

- Avoid using `-c` variable on git wrapped arguments.
  - For some reason, `%ProgramFiles%\Git\bin\bash.exe` overrides `$c` with `$HOME/bash_completion.d/*.bash`.
