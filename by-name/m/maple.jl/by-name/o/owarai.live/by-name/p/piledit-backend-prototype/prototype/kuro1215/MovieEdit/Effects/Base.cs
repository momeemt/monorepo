namespace MovieEdit.Effects
{
    public class Base
    {
        public enum BaseType
        {
            Animation, Effect, Filter
        }

        public string Name { get; }
        public string Explain { get; }
        public BaseType Type { get; }
        private protected object[] Values { get; }

        protected private Base(string name, string explain, object[] value, BaseType type)
        {
            Name = name;
            Explain = explain;
            Type = type;
            Values = value;
        }
    }
}
