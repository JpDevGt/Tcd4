using System;
using System.Collections.Generic;
using System.Linq;
using System.ServiceProcess;
using System.Text;

namespace Tcd4
{
    static class Program
    {
        /// <summary>
        /// Punto de entrada principal para la aplicación.
        /// </summary>
        static void Main()
        {
            

#if DEBUG
            MainService.Proceso();
#else
            
            ServiceBase[] ServicesToRun;
            ServicesToRun = new ServiceBase[]
            {
                new Tcd4()
            };
            ServiceBase.Run(ServicesToRun);
#endif
        }
    }
}
