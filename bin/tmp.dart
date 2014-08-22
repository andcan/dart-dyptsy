import 'dart:io';

void main () {
  RegExp regex = new RegExp(r"""if \(([a-zA-Z0-9]+) == pair\.first\) {\s*return '(\d+)'""", multiLine: true);
  StringBuffer buf = new StringBuffer ();
  regex.allMatches(new File('tmp.txt').readAsStringSync()).forEach((match) {
    
    buf.write("""${match[1]}_LiteCoin: '${match[2]}',\n""");
  });
  print(buf);
}