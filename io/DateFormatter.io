Log4Io DateFormatter := Object clone do(
    format := method(date, dateFormat
        rep := Map clone
        rep atPut("yyyy", "%Y")
        rep atPut("MM", "%m")
        rep atPut("dd", "%d")
        rep atPut("hh", "%H")
        rep atPut("mm", "%M")
        rep atPut("ss", "%S")
        d := date copy
        d format := dateFormat replaceMap(rep)
        d asString
    )
)

Log4Io DateFormatter do (
    DEFAULT_DATE_FORMAT := "yyyy-MM-ddThh:mm:ss0"
)

Log4Io SimpleDateFormat := Log4Io DateFormatter clone do(
    pattern ::= nil
    with := method(pattern,
        self pattern if(pattern isNil, Log4Io DateFormatter DEFAULT_DATE_FORMAT, pattern)
    )
    format := method(date,
        DateFormatter format(date, pattern)
    )
)

