jsoniq version "3.0";
module namespace mm = "ha1lib.jq";
import module namespace file = "http://expath.org/ns/file";
import module namespace math = "http://www.w3.org/2005/xpath-functions/math";
import module namespace r= "http://zorba.io/modules/random";
declare namespace ann = "http://zorba.io/annotations";
import module namespace sctx = "http://zorba.io/modules/sctx";
import module namespace fetch = "http://zorba.io/modules/fetch";
(: import module namespace dgal = "http://dgms.io/modules/analytics";

import module namespace coll = "http://repository.vsnet.gmu.edu/config/collection.jq";
:)

declare function mm:ha1($univDB) {
(:
let $univDB := jn:parse-json(fetch:content("sampleUnivDB.json"))
let $univDB := $jn:parse-json(fetch:content($file))
:)
let $department := $univDB.tables.department[],
    $course := $univDB.tables.course[],
    $prereq := $univDB.tables.prereq[],
    $class := $univDB.tables.class[],
    $faculty := $univDB.tables.faculty[],
    $student := $univDB.tables.student[],
    $enrollment := $univDB.tables.enrollment[],
    $transcript := $univDB.tables.transcript[]
(: boolean queries - each must return true or false :)


let $boolQuery_a := some $st in $student
                    satisfies
                    (some $t in $transcript
                        satisfies ( $t.ssn = $st.ssn and $t.ssn=82
                                    and $t.cno = 530 and $t.dcode = "CS"
                      ))

let $boolQuery_b := some $st in $student
 satisfies $st.name = "John Smith" and
      (some $t in $transcript
       satisfies ($t.cno = 530 and $t.dcode = "CS" and $t.ssn=$st.ssn
        ))

let $boolQuery_c := every $st in $student
 satisfies if ($st.name = "John Smith")
    then (some $t in $transcript
        satisfies($t.ssn = $st.ssn and $t.dcode = "CS" and $t.cno = 530 and $st.name = "John Smith"
        ))
    else true

let $boolQuery_d := some $st in $student
              satisfies $st.ssn = 82 and
              (every $en in $enrollment
              satisfies if ($en.ssn = $st.ssn)
              then (every $cl in $class
              satisfies if ($en.class = $cl.class)
              then (every $pq in $prereq
              satisfies if($pq.dcode = $cl.dcode and $pq.cno = $cl.cno)
              then (some $t in $transcript
              satisfies ($t.dcode = $pq.pcode and $t.cno = $pq.pno and ($t.grade="A" or $t.grade="B") and $t.ssn = $st.ssn)
              )
              else true
              )
              else true
              )
              else true
              )

let $boolQuery_e := every $st in $student
              satisfies
              (every $en in $enrollment
              satisfies if ($en.ssn = $st.ssn)
              then (every $cl in $class
              satisfies if ($en.class = $cl.class)
              then (every $pq in $prereq
              satisfies if($pq.dcode = $cl.dcode and $pq.cno = $cl.cno)
              then (some $t in $transcript
              satisfies ($t.dcode = $pq.pcode and $t.cno = $pq.pno and ($t.grade="A" or $t.grade="B") and $t.ssn = $st.ssn)
              )
              else true
              )
              else true
              )
              else true
              )
let $boolQuery_f := every $st in $student
              satisfies if ($st.major = "CS")
              then (every $en in $enrollment
              satisfies if ($en.ssn = $st.ssn)
              then (every $cl in $class
              satisfies if ($en.class = $cl.class)
              then (every $pq in $prereq
              satisfies if($pq.dcode = $cl.dcode and $pq.cno = $cl.cno)
              then (every $t in $transcript
              satisfies ($t.dcode = $pq.pcode and $t.cno = $pq.pno and ($t.grade="A" or $t.grade="B") and $t.ssn = $st.ssn)
              )
              else true
              )
              else true
              )
              else true
              )
              else true

let $boolQuery_g := some $st in $student
              satisfies $st.name = "John Smith" and
              (some $en in $enrollment
              satisfies if ($en.ssn = $st.ssn)
              then (some $cl in $class
              satisfies if ($en.class = $cl.class)
              then (every $pq in $prereq
              satisfies if($pq.dcode = $cl.dcode and $pq.cno = $cl.cno)
              then (some $t in $transcript
              satisfies ($t.dcode = $pq.pcode and $t.cno = $pq.pno and ($t.grade="A" or $t.grade="B") and $t.ssn = $st.ssn)
              )
              else true
              )
              else true
              )
              else true
              )

let $boolQuery_h := some $co in $course
                    satisfies (every $pq in $prereq
                      satisfies ($co.dcode ne $pq.dcode and $co.cno ne $pq.cno))


let $boolQuery_i := every $cl in $class
                    satisfies (some $pq in $prereq
                      satisfies ($cl.dcode eq $pq.dcode and $cl.cno eq $pq.cno))

let $boolQuery_j := some $st in $student
                    satisfies
                    (every $t in $transcript
                      satisfies if($t.ssn = $st.ssn)
                      then ($t.grade = "A" or $t.grade = "B")
                      else true
                      )




let $boolQuery_k := every $f in $faculty
                    satisfies if($f.name = "Brodsky")
                    then(every $cl in $class
                      satisfies if($f.ssn = $cl.instr)
                      then (every $en in $enrollment
                      satisfies if($en.class = $cl.class)
                      then (some $st in $student
                      satisfies ($st.major="CS" and $en.ssn=$st.ssn)
                    )
                    else true
                    )
                    else true
                    )else true




let $boolQuery_l := some $st in $student
                    satisfies if ($st.major="CS")
                    then (some $en in $enrollment, $cl in $class
                    satisfies if($en.class = $cl.class)
                    then (some $f in $faculty
                    satisfies ($f.name = "Brodsky" and $f.ssn = $cl.instr))
                    else false
                    )
                    else false



(: now data queries; before each one there's a description of output structure :)


let $dataQuery_a := [for $st in $student, $t in $transcript
where ($t.ssn = $st.ssn and $t.dcode = "CS" and $t.cno = 530 )

return {ssn: $st.ssn, name: $st.name, major: $st.major, status: $st.status}]



let $dataQuery_b := [for $st in $student, $t in $transcript
where ( $st.name = "John" and $t.ssn = $st.ssn and $t.dcode = "CS" and $t.cno = 530 )

return {ssn: $st.ssn, name: $st.name, major: $st.major, status: $st.status}]


let $dataQuery_c := [for $st in $student
              where
              (every $en in $enrollment
              satisfies if ($en.ssn = $st.ssn)
              then (every $cl in $class
              satisfies if ($en.class = $cl.class)
              then (every $pq in $prereq
              satisfies if($pq.dcode = $cl.dcode and $pq.cno = $cl.cno)
              then (some $t in $transcript
              satisfies ($t.dcode = $pq.pcode and $t.cno = $pq.pno and ($t.grade="A" or $t.grade="B") and $t.ssn = $st.ssn)
              )
              else true
              )
              else true
              )
              else true
              )
return {ssn: $st.ssn, name: $st.name, major: $st.major, status: $st.status}]
(:not working:)
let $dataQuery_d := [for $st in $student
              where not(every $en in $enrollment
              satisfies if ($en.ssn = $st.ssn)
              then (every $cl in $class
              satisfies if ($en.class = $cl.class)
              then (every $pq in $prereq
              satisfies if($pq.dcode = $cl.dcode and $pq.cno = $cl.cno)
              then (some $t in $transcript
              satisfies ($t.dcode = $pq.pcode and $t.cno = $pq.pno and ($t.grade = "A" or $t.grade = "B") and $t.ssn = $st.ssn)
              )
              else true
              )
              else true
              )
              else true
              )
              order by $st.ssn
              return {ssn: $st.ssn , name: $st.name, major: $st.major, status: $st.status}]


let $dataQuery_e := [for $st in $student
              where  $st.name="John" and
              (some $en in $enrollment
              satisfies if ($en.ssn = $st.ssn)
              then (some $cl in $class
              satisfies if ($en.class = $cl.class)
              then (some $pq in $prereq
              satisfies if($pq.dcode = $cl.dcode and $pq.cno = $cl.cno)
              then (some $t in $transcript
              satisfies ($t.dcode = $pq.pcode and $t.cno = $pq.pno and ($t.grade ne "A" and $t.grade ne "B") and $t.ssn = $st.ssn)
              )
              else false
              )
              else false
              )
              else false
              )
return {ssn: $st.ssn , name: $st.name, major: $st.major, status: $st.status}]

(:not working:)
let $dataQuery_f := [ for $co in $course
                    where not (some $pq in $prereq
                      satisfies $co.dcode = $pq.dcode and $co.cno = $pq.cno)

                      order by $co.dcode, $co.cno
                      return {dcode: $co.dcode, cno: $co.cno}
                      ]


let $dataQuery_g := [for $co in $course
                    where (some $pq in $prereq
                    satisfies ($co.dcode eq $pq.dcode and $co.cno eq $pq.cno))

                    return {dcode: $co.dcode, cno: $co.cno}]

let $dataQuery_h := [for $cl in $class
                      where (some $co in $course
                      satisfies if($co.dcode = $cl.dcode and $co.cno = $cl.cno)
                        then (some $pq in $prereq
                                        satisfies ($co.dcode eq $pq.dcode and $co.cno eq $pq.cno))
                          else false)
                        return {class:$cl.class,dcode: $cl.dcode, cno: $cl.cno, instr: $cl.instr}]

let $dataQuery_i := [for $st in $student
                    where
                    (every $t in $transcript
                      satisfies if($t.ssn = $st.ssn)
                      then ($t.grade = "A" or $t.grade = "B")
                      else true
                      )
             return {ssn: $st.ssn , name: $st.name, major: $st.major, status: $st.status}
                        ]

let $dataQuery_j := [for $st in $student
                    where ($st.major="CS")
                    and (some $en in $enrollment, $cl in $class
                    satisfies if($en.class = $cl.class)
                    then (some $f in $faculty
                    satisfies ($f.name = "Brodsky" and $f.ssn = $cl.instr))
                    else false
                    )
                    return {ssn: $st.ssn , name: $st.name, major: $st.major, status: $st.status}
]

return {
  boolQuery_a: $boolQuery_a,
  boolQuery_b: $boolQuery_b,
  boolQuery_c: $boolQuery_c,
  boolQuery_d: $boolQuery_d,
  boolQuery_e: $boolQuery_e,
  boolQuery_f: $boolQuery_f,
  boolQuery_g: $boolQuery_g,
  boolQuery_h: $boolQuery_h,
  boolQuery_i: $boolQuery_i,
  boolQuery_j: $boolQuery_j,
  boolQuery_k: $boolQuery_k,
  boolQuery_l: $boolQuery_l,
  dataQuery_a: $dataQuery_a,
  dataQuery_b: $dataQuery_b,
  dataQuery_c: $dataQuery_c,
  dataQuery_d: $dataQuery_d,
  dataQuery_e: $dataQuery_e,
  dataQuery_f: $dataQuery_f,
  dataQuery_g: $dataQuery_g,
  dataQuery_h: $dataQuery_h,
  dataQuery_i: $dataQuery_i,
  dataQuery_j: $dataQuery_j
}
};
