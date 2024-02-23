namespace frontend
{
    public partial class App : Application
    {

        public App()
        {
            InitializeComponent();

            MainPage = new MainPage();
        }

        protected override Window CreateWindow(IActivationState activationState)
        {
            Window window = base.CreateWindow(activationState);

            window.MinimumHeight = 1050;
            window.MaximumHeight = 1050;

            window.MinimumWidth = 1200;
            window.MaximumWidth = 1200;

            return window;
        }
    }
}
