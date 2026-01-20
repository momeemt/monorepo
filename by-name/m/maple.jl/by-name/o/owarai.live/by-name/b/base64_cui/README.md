# base64_cui
base64_cui is a very simple application that makes base64 easy to use from a CUI terminal!
How to use it.

## encode
```sh
base64_cui -e example

# ---------------------------------
# encode: ZXhhbXBsZQ==
```

You can encode dozens of times with this.

```sh
base64_cui -e example 10

# ---------------------------------
# encode: Vm0wd2QyVkhVWGhVV0dSUFZsZG9WVll3WkRSV1ZsbDNXa1JTVjFKdGVGWlZNakExVmpGYWRHVkliRmhoTVVwVVZtMXplRmRIVmtWUmJIQk9UVEJLU1ZkV1ZtRlRNazE1Vkd0a2FGSnRVbGhaYkdSdlpWWmFjMVp0UmxkTlZuQlhWRlpXVjJGSFZuRlJWR3M5
```

## decode
Have you ever exchanged dozens of encoded documents with a friend? Decoding over and over again is stressful, but base64_cui will encode multiple times at once. The text can be decoded.

```sh
base64_cui -d Vm0wd2QyVkhVWGhVV0dSUFZsZG9WVll3WkRSV1ZsbDNXa1JTVjFKdGVGWlZNakExVmpGYWRHVkliRmhoTVVwVVZtMXplRmRIVmtWUmJIQk9UVEJLU1ZkV1ZtRlRNazE1Vkd0a2FGSnRVbGhaYkdSdlpWWmFjMVp0UmxkTlZuQlhWRlpXVjJGSFZuRlJWR3M5

# ---------------------------------
# decode: example
```

## encode for twitter
If you want to post a base64 file on Twitter, you can encode it to just under 280 characters, which is the character limit.

```sh
base64_cui -t example
# ---------------------------------
# encode for twitter: Vm0wd2QyUXlWa2hWV0doVlYwZFNVRlpzWkc5V1ZsbDNXa1JTVjFac2JETlhhMUpUVmpGS2RHVkdXbFpOYWtFeFZtcEdZV1JIVmtsaVJtaG9UVlZ3VlZadE1YcGxSbVJJVm10V1VtSklRazlVVkVKTFUxWmtWMVp0UmxSTmF6RTFWa2QwYTJGR1NuUlZiR2hhWWtkU2RscFdXbUZqTVZwMFVteGtUbFp1UWxoV1JscFhWakpHU0ZadVJsSldSM001
```