using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Diagnostics;
using System.Linq;
using System.ServiceProcess;
using System.Configuration;
using System.Text;
using System.Threading.Tasks;

using System.Timers;

namespace Tcd4
{
    public partial class Tcd4 : ServiceBase
    {
        public Tcd4()
        {
            InitializeComponent();
        }

        protected override void OnStart(string[] args)
        {
            Metodos.SetLog("OnStart", "Inicio");
            MainService.Proceso();
            string Tiempo = ConfigurationManager.AppSettings["Tiempo"].ToString();

            Timer timer = new Timer();
            timer.Interval = int.Parse(Tiempo) * 1000;
            timer.Elapsed += new ElapsedEventHandler(this.OnTimer);
            timer.Start();
        }

        protected override void OnStop()
        {
            Metodos.SetLog("OnStop", "Fin");
        }

        public void OnTimer(object sender, ElapsedEventArgs args)
        {
            MainService.Proceso();
        }

    }
}
