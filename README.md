# A small ruby citation tool

## Features

- uses IEEE citation style
- tries to find the company behind the website by doing a WHOIS-Lookup
- if the WHOIS-entry can't be parsed or is in a different format it uses the baseURL as the author
- automatically copies the citation to the clipboard

## Usage

```
ruby cite_url.rb https://de.wikipedia.org/wiki/Edward_Snowden
```

Output:
```
Wikimedia Foundation, Inc., "Edward Snowden – Wikipedia", 2016. [Online]. Verfügbar: https://de.wikipedia.org/wiki/Edward_Snowden. [Zugriff am 21.04.2016].
```
