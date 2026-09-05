import "@typespec/json-schema";
using TypeSpec.JsonSchema;

@jsonSchema("/modules/userbrew.json")
model UserbrewModule {
    /** <Short description of the module>
    * 
    */
    type: "userbrew",
}