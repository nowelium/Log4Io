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

