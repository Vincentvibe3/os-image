import "@typespec/json-schema";
using TypeSpec.JsonSchema;

@jsonSchema("/modules/poly-tmp.json")
model PolyTmpModule {
    /** <Short description of the module>
    * 
    */
    type: "poly-tmp",
}