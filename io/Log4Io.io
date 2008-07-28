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
    import ::= System launchPath

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

    forward := method(
        name := call message name
        file := File with(import .. "/" .. (name) .. ".io")
        if(file exists) then (
            self doFile(file path)
            return self getSlot(name)
        ) else (
            Exception raise("Not imported Io: " .. file path)
        )
    )
)

log4ioLogger := Log4Io getLogger("Log4Io")
log4ioLogger addAppender(Log4Io ConsoleAppender with)
log4ioLogger setLevel(Log4Io Level ALL)

