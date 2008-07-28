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

