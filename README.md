# cbDeepl

Implements Deepl Api machine translation for Coldbox Coldfusion
See https://www.deepl.com/api.html

Try deepl here https://www.deepl.com/translator

## Installation

You will need a Deepl Account to work with this API
Attention this Api is commercial, you can't use it without buying translation packages
See here: https://www.deepl.com/pro.html


This API can be installed as standalone or as a ColdBox Module.  Either approach requires a simple CommandBox command:

```
box install cbDeepl
```

Then follow either the standalone or module instructions below.

### Standalone

This API will be installed into a directory called `cbDeepl` and then the API can be instantiated via `new cbDeepl.models.DeeplClient()` with the following constructor arguments:

```
<cfargument name="apiKey"             required="true">
```

### ColdBox Module

This package also is a ColdBox module as well.  The module can be configured by adding `DeeplApiKey` in your application configuration file: `config/Coldbox.cfc` with the following settings:

```
    settings = {

        // Your Deepl API Key
        DeeplApiKey = "",

        // Your settings....

    };
```

Then you can leverage the API CFC via the injection DSL: `DeeplClient@cbDeepl`

## Usage

```
/**
* A normal ColdBox Event Handler
*/
component{
    property name="deepl" inject="DeeplClient@cbDeepl";

    function index(event,rc,prc){

        // returns translated text as string
        var t=deepl.translate('Italy, Tuscany, View out of window to the garden of land house','en','de');
        writeDump(t);

        abort;
    }
}
```

## Written by
www.akitogo.com

## Thanks
To @harryk for adding a more general getLanguages()

## Disclaimer
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.