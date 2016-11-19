package md55dd0438f3d3787805cb2fb6132c99ade;


public abstract class MvxPreferenceFragment_1
	extends mvvmcross.droid.fullfragging.fragments.MvxPreferenceFragment
	implements
		mono.android.IGCUserPeer
{
/** @hide */
	public static final String __md_methods;
	static {
		__md_methods = 
			"";
		mono.android.Runtime.register ("MvvmCross.Droid.FullFragging.Fragments.MvxPreferenceFragment`1, MvvmCross.Droid.FullFragging, Version=4.0.0.0, Culture=neutral, PublicKeyToken=null", MvxPreferenceFragment_1.class, __md_methods);
	}


	public MvxPreferenceFragment_1 () throws java.lang.Throwable
	{
		super ();
		if (getClass () == MvxPreferenceFragment_1.class)
			mono.android.TypeManager.Activate ("MvvmCross.Droid.FullFragging.Fragments.MvxPreferenceFragment`1, MvvmCross.Droid.FullFragging, Version=4.0.0.0, Culture=neutral, PublicKeyToken=null", "", this, new java.lang.Object[] {  });
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
