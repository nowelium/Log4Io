Log4Io Logger := Object clone do(
    level ::= nil
    dateFormat ::= nil
    with := method(name,
        c := self clone
        c category := if(name isNil, "", name)
        c dateformat := Log4Io DateFormatter DEFAULT_DATE_FORMAT
        c dateformatter := Log4Io DateFormatter clone
        c onlog := Log4Io EventListener clone
        c onclear := Log4Io EventListener clone
        c loggingEvents := List clone
        c appenders := List clone
        c level := nil
        c appenders append(Log4Io Appender with(c))
        c
    )
    addAppender := method(appender,
        if(appender isKindOf(Log4Io Appender) not) then(
            Exception raise("Not kindOf an Appender: " .. appender)
        )
        appender setLogger(self)
        appenders append(appender)
    )
    setAppenders := method(appenders,
        self appenders foreach(appender, appender doClear)
        self appenders = appenders
        self appenders foreach(appender,
            appender setLogger(self)
        )
    )
    getFormattedTimestamp := method(date,
        self dateformatter format(date, dateformat)
    )
)

Log4Io Logger do(
    log := method(level, message, exception,
        event := Log4Io LoggingEvent with(category, level, message, exception, self)
        loggingEvents append(event)
        onlog dispatch(event)
    )
    clear := method(
        e := try(
            loggingEvents = List clone
            onclear dispatch
        )
        e pass
    )
    isTraceEnabled := method(
        level valueOf <= Log4Io Level TRACE valueOf
    )
    trace := method(message, exception,
        log(Log4Io Level TRACE, message, exception)
    )
    isDebugEnabled := method(
        level valueOf <= Log4Io Level DEBUG valueOf
    )
    debug := method(message, exception,
        log(Log4Io Level DEBUG, message, exception)
    )
    isInfoEnabled := method(
        level valueOf <= Log4Io Level INFO valueOf
    )
    info := method(message, exception,
        log(Log4Io Level INFO, message, exception)
    )
    isWarnEnabled := method(
        level valueOf <= Log4Io Level WARN valueOf
    )
    warn := method(message, exception,
        log(Log4Io Level WARN, message, exception)
    )
    ifErrorEnabled := method(
        level valueOf <= Log4Io Level ERROR valueOf
    )
    error := method(message, exception,
        log(Log4Io Level ERROR, message, exception)
    )
    isFatalEnabled := method(
        level valueOf <= Log4Io Level FATAL valueOf
    )
    fatal := method(message, exception,
        log(Log4Io Level FATAL, message, exception)
    )
)

