using System;

namespace XSLTParserTesting
{
    public class HtmlTransformationException : Exception
    {
        public HtmlTransformationException(string message, Exception innerException)
            : base(message, innerException)
        { }
    }
}