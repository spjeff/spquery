## Description
WinForm - run TSQL query across all SharePoint content databases

Can be useful with support and troubleshooting to identify the scope, usage, and instances for a given
feature or configuration setting.   Use with caution as direct SQL database query is not supported.  
Recommend using "NOLOCK" hint and running query after business hours.

[![](https://raw.githubusercontent.com/spjeff/spquery/master/doc/download.png)](https://github.com/spjeff/spquery/releases/download/spquery/SPQuery.ps1)

## Features
* Simple GUI to loop a given SQL query across all local SharePoint farm content databases
* Grid view  results can be copy/pasted to Excel  
* Form contains two buttons - `Run` and `Save`  
* `Run` will execute a query across all databases
* `Save` generates a XML file with all results.  Useful for large result sets that are too big to copy/paste with clipboard.


## Screenshots
![image](https://raw.githubusercontent.com/spjeff/spquery/master/doc/1.png)
![image](https://raw.githubusercontent.com/spjeff/spquery/master/doc/2.png)

## Contact
Please drop a line to [@spjeff](https://twitter.com/spjeff) or [spjeff@spjeff.com](mailto:spjeff@spjeff.com)
Thanks!  =)

![image](http://img.shields.io/badge/first--timers--only-friendly-blue.svg?style=flat-square)


## License

The MIT License (MIT)

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.