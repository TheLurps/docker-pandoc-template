# docker-pandoc

A docker image for generating PDFs from Markdown using Pandoc and Miktex

## Usage

Create docker volume to store Miktex packages

```bash
docker create --name miktex
```

### Run locally

```bash
docker run --rm -ti \
    -v miktex:/miktex/.miktex \
    -v $(pwd):/miktex/work \
    -e VERSION=$(git log -1 --format=format:"%H") \
    -e MIKTEX_GID=$(id -g) \
    -e MIKTEX_UID=$(id -u) \
    thelurps/pandoc:latest make all
```

### Run in GitHub

- add `.github/workflows/pandoc.yml`

```yaml
name: Pandoc

on:
  push:
    branches:
      - "main"
  workflow_dispatch:

jobs:
  build:
    runs-on: ubuntu-latest
    container: thelurps/pandoc:latest
    env:
      VERSION: ${{ github.sha }}
    steps:
      - uses: actions/checkout@v2
      - name: Render
        run: make all
      - uses: actions/upload-artifact@master
        with:
          name: 'rendered_pdf-${{ env.VERSION }}'
          path: '*-${{ env.VERSION }}.pdf'
```

### Run in GitLab

- add `.gitlab-ci.yml`

```yaml
build:
  image: thelurps/pandoc:latest
  rules:
    - if: '$CI_COMMIT_BRANCH == "main"'
  script:
    - make all
  variables:
    VERSION: $CI_COMMIT_SHA 
  artifacts:
    paths:
      - "*-$VERSION.pdf"
```

## More sample text

An unordered listing:

- item a
- item b
- item c

A ordered listing:

1. item a
1. item b
1. item c

Some code:

```python
for e in elements:
    print(e)
```

This is a sample citation @dominici2014overview.

A formular using Markdown inline math: $f(x) = x^2$

A formular using Markdown outline math:

$$F(x) = \int^a_b \frac{1}{3} X^3$$

A full blown \LaTeX equation is shown in equation \ref{eq:demo}:

\begin{equation}\label{eq:demo}
E_r = E_t \cdot C_t \cdot C_r \cdot d^{-2} \cdot e^{-2 \, b \, d} \cdot \cos{\vartheta} \cdot f(c_s)
\end{equation}

A figure included as PDF file is shown as {+@fig:demo}:

![A demo figure](fig_demo.pdf){#fig:demo width=50%}

Some acronyms like (+lcm) or (+gcd). And again (+lcm) and (+gcd).

# References
