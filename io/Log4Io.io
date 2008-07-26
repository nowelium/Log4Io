Block apply := method(target, args,
    args = if(args isNil, list(), args)
    target = if(target isNil, scope, target)
    self setScope(target)
    self performWithArgList("call", args)
)
Block bind := method(
    args := call message argsEvaluatedIn(call sender)
    target := args at(0)
    args = args slice(1)
    b := self
    return block(
        b apply(target, args union(call message argsEvaluatedIn(call sender)))
    )
)
Block curry := method(
    args := call message argsEvaluatedIn(call sender)
    if(args size < 1) then (
        return self
    )
    b := self
    return block(
        b apply(scope, args union(call message argsEvaluatedIn(call sender)))
    )
)

Log4Io := Object clone do(
    version := "0.01"
    applicationStartDate ::= Date clone
    loggers ::= Map clone
    clone = method(self)
    init = method(nil)

    getLogger := method(categoryName,
        if(categoryName isKindOf(Sequence) not) then (
            categoryName = "root"
        )
        if(loggers hasKey(categoryName) not) then (
            loggers atPut(categoryName, Log4Io Logger with(categoryName))
        )
        loggers at(categoryName)
    )
    getRootLogger := method(getLogger("root"))
)

Log4Io CustomEvent := Object clone do(
    init := method(
        self listeners ::= List clone
    )
    addListener := method(listener,
        listeners append(listener)
    )
    removeListener := method(listener,
        findListenerIndexes(listener) foreach(i,
            listeners removeAt(i)
        )
    )
    dispatch := method(handler,
        listeners foreach(listener,
            e := try(
                listener call(handler)
            )
            e catch(Exception,
                Exception raise("could not run the listener: " .. listener .. "\n" .. e)
            )
        )
    )
    findListenerIndexes := method(listener,
        indexes := List clone
        listeners foreach(index, value,
            if(value == listener) then(
                indexes append(index)
            )
        )
        indexes
    )
)

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

Log4Io Logger := Object clone do(
    level ::= nil
    dateFormat ::= nil
    with := method(name,
        c := self clone
        c category := if(name isNil, "", name)
        c dateformat := Log4Io DateFormatter DEFAULT_DATE_FORMAT
        c dateformatter := Log4Io DateFormatter clone
        c onlog := Log4Io CustomEvent clone
        c onclear := Log4Io CustomEvent clone
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

Log4Io LoggingEvent := Object clone do(
    startTime := nil
    categoryName := nil
    message := nil
    exception := nil
    level := nil
    logger := nil

    with := method(categoryName, level, message, exception, logger,
        c := self clone
        c startTime := Date clone
        c categoryName = categoryName
        c level = level
        c message = message
        c exception = exception
        c logger = logger
        c
    )
    getFormattedTimestamp := method(
        if(logger isNil not) then(
            return logger getFormattedTimestamp(startTime)
        )
        return startTime asAtomDate
    )
)

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

Log4Io PatternLayout := Log4Io Layout clone do(
    pattern ::= nil
    Formatter := Object clone do(
        loggingEvent ::= nil
        format := method(source,
            buf := Sequence clone asBuffer
            regex := Regex with("%(-?[0-9]+)?(\.?[0-9]+)?([cdmnpr%])(\{([^\}]+)\})?|([^%]+)")
            regex matchesIn(source) map(match,
                holder := match string
                value := if(hasSlot(holder), perform(holder), holder)
                buf appendSeq(value)
            )
            buf asString
        )
        setSlot("%c", method(
            loggingEvent categoryName
        ))
        setSlot("%d", method(
            format := Log4Io SimpleDateFormat with(Log4Io PatternLayout ISO8601_DATEFORMAT)
            format format(loggingEvent startTime)
        ))
        setSlot("%m", method(
            loggingEvent message
        ))
        setSlot("%n", method(
            "\n"
        ))
        setSlot("%p", method(
            loggingEvent level asString
        ))
        setSlot("%r", method(
            loggingEvent startTime asString
        ))
        setSlot("%%", method(
            "%"
        ))
    )
    with := method(pattern,
        c := self clone
        if(pattern isNil not) then (
            c pattern = pattern
        ) else (
            c pattern = Log4Io PatternLayout DEFAULT_CONVERSION_PATTERN
        )
        c
    )
    format := method(event,
        formatter := Formatter clone
        formatter setLoggingEvent(event)
        formatter format(pattern)
    )
)

Log4Io PatternLayout do (
    TTCC_CONVERSION_PATTERN := "%r %p %c - %m%n"
    DEFAULT_CONVERSION_PATTERN := "%m%n"

    ISO8601_DATEFORMAT := "yyyy-MM-dd HH:mm:ss,SSS"
    DATETIME_DATEFORMAT := "dd MMM YYY HH:mm:ss,SSS"
    ABSOLUTETIME_DATEFORMAT := "HH:mm:ss,SSS"
)
Log4Io Appender := Object clone do(
    logger ::= nil
    layout ::= nil

    with := method()

    doAppend := block(event, nil)
    doClear := block()

    setLogger := method(logger,
        logger onlog addListener(self doAppend bind(self))
        logger onclear addListener(self doClear bind(self))

        self logger = logger
    )
)

Log4Io ConsoleAppender := Log4Io Appender clone do(
    with = method(
        c := self clone
        c layout = Log4Io PatternLayout with(Log4Io PatternLayout TTCC_CONVERSION_PATTERN)
        c
    )

    doAppend := block(event,
        write(layout format(event))
    )

    asString := method(
        "Log4Io ConsoleAppender"
    )
)

Log4Io FileAppender := Log4Io Appender clone do(
    file ::= nil
    with = method(path,
        filePath = if(path isNil, "log4io.log", path)
        c := self clone
        c file := File with(filePath)
        c layout = Log4Io SimpleLayout with
        c
    )

    doAppend := block(event,
        e := try(
            if(file isOpen not) then (
                file openForAppending
            )
            file write(layout format(event))
            file close
        )
        e catch(Exception,
            log4ioLogger error(e)
        )
    )

    doClear := block(
        e := try(
            if(file isOpen not) then(
                file open
            )
            file setContents("")
            file close
        )
        e catch(Exception,
            log4ioLogger error(e)
        )
    )

    asString := method(
        "Log4Io FileAppender[" .. file contents .. "]"
    )
)
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

log4ioLogger := Log4Io getLogger("Log4Io")
log4ioLogger addAppender(Log4Io ConsoleAppender with)
log4ioLogger setLevel(Log4Io Level ALL)

