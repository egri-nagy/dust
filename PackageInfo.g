SetPackageInfo( rec(

PackageName := "dust",

Subtitle := "Extra Data Strucutre for GAP",

Version := "0.1",

Date := "22/06/2012",

ArchiveURL := "http://sgpdec.sf.net",

ArchiveFormats := ".tar.gz",

Persons := [
  rec(
    LastName      := "Egri-Nagy",
    FirstNames    := "Attila",
    IsAuthor      := true,
    IsMaintainer  := true,
    Email         := "attila@egri-nagy.hu",
    WWWHome       := "http://www.egri-nagy.hu",
    PostalAddress := Concatenation( [
                       "University of Hertfordshire\n",
                       "University of Western Sydney\n"] ),
    Place         := "Hatfield UK, Sydney Australia",
    Institution   := "UH,UWS"
  )
],

Status := "dev",

README_URL := "https://bitbucket.org/dersu/dust",

PackageInfoURL := "https://bitbucket.org/dersu/dust",


AbstractHTML :=
  "<span class=\"pkgname\">dust</span> is  a <span class=\"pkgname\">GAP</span> package \
   for extra data structures like associative lists, lazy cartesian products, etc.",

PackageWWWHome := "https://bitbucket.org/dersu/dust",

PackageDoc := rec(
  BookName  := "dust",
  ArchiveURLSubset := ["doc","htm"],
  HTMLStart := "doc/manual.htm",
  PDFFile   := "doc/manual.pdf",
  SixFile   := "doc/manual.six",
  LongTitle := "Extra Data Structures for GAP",
  Autoload  := true
),


Dependencies := rec(
 GAP := ">=4.5.4",
                   NeededOtherPackages := [];
#[["GAPDoc", ">= 1.2"],  #StringPrint
                   #["citrus", ">= 0.1"], #orbit algorithms
                   #["orb", ">= 3.7"], #hashtable functionalities
                   #["viz", ">= 0.1"] #Draw, Splash
                   #      ],
 SuggestedOtherPackages := [ ],
 ExternalConditions := []
),

AvailabilityTest := ReturnTrue,

Autoload := false,

TestFile := "test/test.g",

Keywords := ["data structure"]
));
