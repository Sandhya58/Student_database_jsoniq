jsoniq version "3.0";
import module namespace file = "http://expath.org/ns/file";
import module namespace math = "http://www.w3.org/2005/xpath-functions/math";
import module namespace r= "http://zorba.io/modules/random";
declare namespace ann = "http://zorba.io/annotations";
import module namespace sctx = "http://zorba.io/modules/sctx";
import module namespace fetch = "http://zorba.io/modules/fetch";
import module namespace ha = "ha1lib.jq";
(: import module namespace dgal = "http://dgms.io/modules/analytics";

import module namespace coll = "http://repository.vsnet.gmu.edu/config/collection.jq";
:)
let $db1 := jn:parse-json(fetch:content("testDBs/db1.json"))
let $db2 := jn:parse-json(fetch:content("testDBs/db2.json"))
let $db3 := jn:parse-json(fetch:content("testDBs/db3.json"))
let $db4 := jn:parse-json(fetch:content("testDBs/db4.json"))
let $db5 := jn:parse-json(fetch:content("testDBs/db5.json"))
let $db6 := jn:parse-json(fetch:content("testDBs/db6.json"))
let $db7 := jn:parse-json(fetch:content("testDBs/db7.json"))
let $db8 := jn:parse-json(fetch:content("testDBs/db8.json"))
let $db9 := jn:parse-json(fetch:content("testDBs/db9.json"))
let $db10 := jn:parse-json(fetch:content("testDBs/db10.json"))
let $db11 := jn:parse-json(fetch:content("testDBs/db11.json"))
let $db12 := jn:parse-json(fetch:content("testDBs/db12.json"))

let $answers := {
  db1: ha:ha1($db1),
  db2: ha:ha1($db2),
  db3: ha:ha1($db3),
  db4: ha:ha1($db4),
  db5: ha:ha1($db5),
  db6: ha:ha1($db6),
  db7: ha:ha1($db7),
  db8: ha:ha1($db8),
  db9: ha:ha1($db9),
  db10: ha:ha1($db10),
  db11: ha:ha1($db11),
  db12: ha:ha1($db12)
}
return $answers
