Log4Io Level := Object clone do(
    level ::= nil
    name ::= nil
    with := method(level, name,
        self clone setLevel(level) setName(name)
    )
    toLevel := method(level, defaultLevel,
        if(level isNil) then(
            return defaultLevel
        )
        if(level isKindOf(Sequence)) then(
            return level asUppercase switch(
                ALL name, ALL,
                DEBUG name, DEBUG,
                INFO name, INFO,
                WARN name, WARN,
                ERROR name, ERROR,
                FATAL name, FATAL,
                OFF name, OFF,
                TRACE name, TRACE,
                defaultLevel
            )
        )
        if(level isKindOf(Number)) then(
            return level switch(
                ALL_INT, ALL,
                DEBUG_INT, DEBUG,
                INFO_INT, INFO,
                WARN_INT, WARN,
                ERROR_INT, ERROR,
                FATAL_INT, FATAL,
                OFF_INT, OFF,
                TRACE_INT, TRACE,
                defaultLevel
            )
        )
        defaultLevel
    )
    asString := method(name)
    valueOf := method(level)
)

Log4Io Level do(
    OFF_INT := Number integerMax
    FATAL_INT := 50000
    ERROR_INT := 40000
    WARN_INT := 30000
    INFO_INT := 20000
    DEBUG_INT := 10000
    TRACE_INT := 5000
    ALL_INT := Number integerMin
)

Log4Io Level do(
    OFF := Log4Io Level with(OFF_INT, "OFF")
    FATAL := Log4Io Level with(FATAL_INT, "FATAL")
    ERROR := Log4Io Level with(ERROR_INT, "ERROR")
    WARN := Log4Io Level with(WARN_INT, "WARN")
    INFO := Log4Io Level with(INFO_INT, "INFO")
    DEBUG := Log4Io Level with(DEBUG_INT, "DEBUG")
    TRACE := Log4Io Level with(TRACE_INT, "TRACE")
    ALL := Log4Io Level with(ALL_INT, "ALL")
)

