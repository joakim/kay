-- every cell has an `on` receptor and an `events` cell
-- (this is just an exploration of a possible api/syntax)

-- subject cells emit events
subject: {
    -- change event (predefined)
    events emit change: [
        old: -- ...
        new: -- ...
    ]
    
    -- error event (predefined)
    events emit error: (Error "oh noes")
    
    -- custom event
    events add "custom"
    events emit
        name: "custom"
        data: [foo: 42, bar: true]
}

-- observing cells subscribe to events by signaling the subject's `on` receptor
-- `on` is a receptor that returns a cell with receptors for registered events
-- these event receptors return a token for unsubscribing at a later time
-- observers should be held as weak references to prevent memory leaks
observer: {
    -- subscribe to events
    subject on
        | change: event => print event    --> [old: ..., new: ...]
        | error: error => log error       --> [message: "oh noes", line: 13, row: 24]
    
    -- subscribe to custom event
    subject on "custom": event => print event.data  --> [foo: 42, bar: true]
    
    -- unsubscribe from event
    subject unsubscribe from: "custom"
}
