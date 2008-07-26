Log4Io
log4ioLogger error("hoge")
log4ioLogger info("foo")
log4ioLogger warn("bar")

logger := Log4Io getLogger("sample")
logger addAppender(Log4Io ConsoleAppender with)
logger setLevel(Log4Io Level INFO)
if(logger isDebugEnabled) then (
    logger debug("debug")
)
if(logger isInfoEnabled) then (
    logger info("info")
)
if(logger isWarnEnabled) then (
    logger warn("warn")
)
