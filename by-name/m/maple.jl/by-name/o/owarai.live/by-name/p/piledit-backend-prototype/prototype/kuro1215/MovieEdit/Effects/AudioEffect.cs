using System;
using System.Collections.Generic;
using System.Text;

namespace MovieEdit.Effects
{
    public static class AudioEffect
    {
        

    }

    public abstract class AudioEffectBase : Base
    {
        protected private AudioEffectBase(string name, string explain, object[] value)
            : base(name, explain, value, BaseType.Effect) { }

        public abstract object Processing(object source);
    }
}
