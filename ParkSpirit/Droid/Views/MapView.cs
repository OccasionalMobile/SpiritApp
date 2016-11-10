using System;
using Android.App;
using MvvmCross.Droid.Views;
using Android.OS;
using MvvmCross.Droid.FullFragging;


namespace ParkSpirit.Droid
{
	[Activity(Label = "View for MapViewModel")]
	public class MapView : MvxActivity
	{
		protected override void OnCreate(Bundle bundle)
		{
			base.OnCreate(bundle);
			SetContentView(Resource.Layout.FirstView);
			//var mapFrag = new Map
		}
		public MapView()
		{
			
		}

	}
}
