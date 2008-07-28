Log4Io Layout := Object clone do (
    separator ::= ""
    init := method(nil)
    with := method()
    format := method(event,
        ""
    )
    getSeparator := method(separator)
)

Log4Io SimpleLayout := Log4Io Layout clone do (
    with = method(
        setSeparator("\n")
    )

    format = method(event,
        event level asString .. " - " .. event message .. separator
    )
)

Log4Io BasicLayout := Log4Io Layout clone do(
    with = method(
        setSeparator("\n")
    )

    format = method(event,
        event categoryName .. "~" .. event startTime asString .. "[" .. event level asString .. "]" .. event message .. separator
    )
)

