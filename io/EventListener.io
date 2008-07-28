Log4Io EventListener := Object clone do(
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

