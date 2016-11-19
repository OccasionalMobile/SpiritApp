package mvvmcross.droid.fullfragging.fragments;


public abstract class MvxPreferenceFragment
	extends mvvmcross.droid.fullfragging.fragments.eventsource.MvxEventSourcePreferenceFragment
	implements
		mono.android.IGCUserPeer
{
/** @hide */
	public static final String __md_methods;
	static {
		__md_methods = 
			"";
		mono.android.Runtime.register ("MvvmCross.Droid.FullFragging.Fragments.MvxPreferenceFragment, MvvmCross.Droid.FullFragging, Version=4.0.0.0, Culture=neutral, PublicKeyToken=null", MvxPreferenceFragment.class, __md_methods);
	}


	public MvxPreferenceFragment () throws java.lang.Throwable
	{
		super ();
		if (getClass () == MvxPreferenceFragment.class)
			mono.android.TypeManager.Activate ("MvvmCross.Droid.FullFragging.Fragments.MvxPreferenceFragment, MvvmCross.Droid.FullFragging, Version=4.0.0.0, Culture=neutral, PublicKeyToken=null", "", this, new java.lang.Object[] {  });
	}

	private java.util.ArrayList refList;
	public void monodroidAddReference (java.lang.Object obj)
	{
		if (refList == null)
			refList = new java.util.ArrayList ();
		refList.add (obj);
	}

	public void monodroidClearReferences ()
	{
		if (refList != null)
			refList.clear ();
	}
}
