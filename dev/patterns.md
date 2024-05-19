# HWDB dev pattern recognition

- form cubits usually contain event and error fields

- event and error fields shoul dbe set to Events.none and Errors.none in copyWiths (for BlocListeners)

- (?) Validation Errors should be set to const {} in copyWiths

- cubits don't have to remove null fields from maps thanks to our http client
    - eg. we don't need to {if (value != null) 'key': value}

- we can return things with Routes and do things after the Route is popped. This could be used in form Routes for returning submitted content

- initialValue for enum dropdowns should be null or a type that exist in the dropdown option list

- db and server operations can be repeated in different cubits if reusing cubits don't make sense
    - (?) we shouldn't pass any cubits around (i.e. no BlocProvider.value)

- api functions do not have to be mutually exclusive (independent and orthogonal) as well. 
    - one function might be a subset of another

- extract widgets in builders for proper theme changes & rebuild
    - eg: extracted widgets will rebuild when light & dark theme changes

- (??) keys in mongo documents should always be semantic
    - (!) as every field can be an index

- (??) always copy collections (Lists, Sets, Maps) to update them in the ui
    - context.select only rebuilds on new collections

- "shoulds" for dev ease and utility always >> "shoulds" for semantics

- don't define custom types unless necessary as it may induce unexpected behavior and bugs

- repetition makes independence

- explanatory/imperative comments start with `Ensure`, `Get`, `Validate`, `Save`, `Write`, `Return`, `If`, `Update`, `Calculate`, `Send`, `Delete`, `Construct`, `Convert`, `Determine`.

- labeling comments should be full upper case (eg. `USER NAME TEXTFIELD`)