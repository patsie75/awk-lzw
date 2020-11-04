#!/usr/bin/awk -f

function LZWencode(input, encoded,    inputlen, dictlen, i, chr, buf, len) {
  ## initialize dictionary
  for (dictlen=0; dictlen<256; dictlen++)
    dict[sprintf("%c", dictlen)] = dictlen

  inputlen = length(input)

  ## loop over input data
  for (i=1; i<=inputlen; i++) {
    ## get next character
    chr = substr(input, i, 1)

    if ( buf""chr in dict ) {
      ## append char to buffer
      buf = buf""chr
    } else {
      ## add buf to encoded data and reset buffer
      encoded[len++] = dict[buf]
      dict[buf""chr] = dictlen++
      buf = chr
    }
  }

  ## add last buffer data to encoded data
  encoded[len++] = dict[buf]

  ## return length of encoded data
  return(len)
}


function LZWdecode(encoded, size, output,    dictsize, dictionary, len, w, result, k, chr, entry) {
  ## decode table
  for (dictsize=0; dictsize<256; dictsize++)
    dictionary[dictsize] = sprintf("%c", dictsize)

  len = length(encoded)

  w = dictionary[encoded[0]]
  result = w

  for (k=1; k<len; k++) {
    chr = encoded[k];
    if (chr in dictionary) {
      entry = dictionary[chr]
    } else if (chr == dictsize) {
      entry = w substr(w,1,1)
    } else {
      printf("Bad compressed value: %s\n", chr)
      exit(1)
    }

    result = result entry
    dictionary[dictsize++] = w substr(entry, 1,1)

    w = entry
  }

  return(result)
}


BEGIN {
  input = "TOBEORNOTTOBEORTOBEORNOT"

  ## encode input data
  LZWencode(input, encoded)

  # print encoded data
  for (i=0; i<length(encoded); i++)
    printf("%d ", encoded[i])
  printf("\n")

  # decode and print result
  print LZWdecode(encoded, output)
}
