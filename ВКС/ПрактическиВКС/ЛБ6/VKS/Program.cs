using System;
using System.Linq;
using System.Collections.Generic;

namespace VKS
{
	class Program
	{
		static void Main()
		{
			for(int i = 0; i < 5; i++)
				ArrayUtils.OutputArray<int>(ArrayUtils.GenerateRandomNumericalArray(10, 0, 2));
		}
	}
}
