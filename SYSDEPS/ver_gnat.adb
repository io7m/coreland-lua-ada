-- auto generated, do not edit
with GNAT.Compiler_Version;
with GNAT.Regpat;
with Ada.Text_IO;
with Ada.Strings.Fixed;
with Ada.Strings;
procedure ver_GNAT is
  --
  -- gnatver.ads
  --
  type variant_t is
    (GNAT_UNKNOWN,
     GNAT_FSF,
     GNAT_GPL,
     GNAT_PRO,
     GNAT_GAP);
  type version_t is record
    variant : variant_t := GNAT_UNKNOWN;
    major   : Natural   := 0;
    minor   : Natural   := 0;
    patch   : Natural   := 0;
  end record;
  procedure decode
    (version : out version_t;
     image   : in String);
  procedure decode_current
    (version : out version_t);
  --
  -- gnatver.adb
  --
  package ver is new GNAT.Compiler_Version;
  use type GNAT.Regpat.Match_Location;
  regex_FSF : constant String := "^(GNAT Version: ){0,1}([0-9]).([0-9]).([0-9])";
  regex_GPL : constant String := "^(GNAT Version: ){0,1}GPL [0-9]+ \(([0-9]{4})([0-9]{2})([0-9]{2})\)";
  regex_GAP : constant String := "^(GNAT Version: ){0,1}GAP [0-9]+ \(([0-9]{4})([0-9]{2})([0-9]{2})\)";
  regex_Pro : constant String := "^(GNAT Version: ){0,1}Pro ([0-9]).([0-9]).([0-9])";
  procedure decode
    (version : out version_t;
     image   : in String)
  is
    matches : GNAT.Regpat.Match_Array (0 .. 4);
  begin
    -- check FSF
    GNAT.Regpat.Match
      (expression => regex_FSF,
       data       => image,
       matches    => matches);
    if matches (0) /= GNAT.Regpat.No_Match then
      version.variant := GNAT_FSF;
      version.major   := Natural'Value (image (matches (2).First ..  matches (2).Last));
      version.minor   := Natural'Value (image (matches (3).First ..  matches (3).Last));
      version.patch   := Natural'Value (image (matches (4).First ..  matches (4).Last));
    end if;
    -- check GPL
    GNAT.Regpat.Match
      (expression => regex_GPL,
       data       => image,
       matches    => matches);
    if matches (0) /= GNAT.Regpat.No_Match then
      version.variant := GNAT_GPL;
      version.major   := Natural'Value (image (matches (2).First ..  matches (2).Last));
      version.minor   := Natural'Value (image (matches (3).First ..  matches (3).Last));
      version.patch   := Natural'Value (image (matches (4).First ..  matches (4).Last));
    end if;
    -- check GAP
    GNAT.Regpat.Match
      (expression => regex_GAP,
       data       => image,
       matches    => matches);
    if matches (0) /= GNAT.Regpat.No_Match then
      version.variant := GNAT_GAP;
      version.major   := Natural'Value (image (matches (2).First ..  matches (2).Last));
      version.minor   := Natural'Value (image (matches (3).First ..  matches (3).Last));
      version.patch   := Natural'Value (image (matches (4).First ..  matches (4).Last));
    end if;
    -- check Pro
    GNAT.Regpat.Match
      (expression => regex_Pro,
       data       => image,
       matches    => matches);
    if matches (0) /= GNAT.Regpat.No_Match then
      version.variant := GNAT_PRO;
      version.major   := Natural'Value (image (matches (2).First ..  matches (2).Last));
      version.minor   := Natural'Value (image (matches (3).First ..  matches (3).Last));
      version.patch   := Natural'Value (image (matches (4).First ..  matches (4).Last));
    end if;
  end decode;
  procedure decode_current
    (version : out version_t) is
  begin
    decode
      (version => version,
       image   => ver.Version);
  end decode_current;
  -- ver_GNAT.adb
  function To_String (num : Integer) return String is
  begin
    return Ada.Strings.Fixed.Trim (Integer'Image (num), Ada.Strings.Left);
  end To_String;
  version : version_t;
begin
  decode_current (version);
  Ada.Text_IO.Put_Line
    (variant_t'Image (version.variant) & " " &
     To_String (version.major) & "." &
     To_String (version.minor) & "." &
     To_String (version.patch));
end ver_GNAT;
