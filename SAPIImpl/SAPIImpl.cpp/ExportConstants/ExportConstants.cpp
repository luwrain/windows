// ExportConstants.cpp : Выводит код класса java, содержащий список необходимых констант
//

#include "stdafx.h"

#include <sapi.h>

#include <iostream>
using namespace std;

int _tmain(int argc, _TCHAR* argv[])
{
	wcout <<
			  L"package org.luwrain.windows.speech;"
		L"\n"
		L"\n" L"class  SAPIImpl_constants"
		L"\n" L"{"
		L"\n" L"	// link to documentation https://msdn.microsoft.com/en-us/library/ee431843%28v=vs.85%29.aspx"
		L"\n" L"	public static final int SPF_IS_XML = " << SPF_IS_XML << L";"
		L"\n" L"	public static final int SPF_IS_NOT_XML = " << SPF_IS_NOT_XML << L";"
		L"\n" L"	public static final int SPF_ASYNC = " << SPF_ASYNC << L";"
		L"\n" L"	public static final int SPF_PURGEBEFORESPEAK = " << SPF_PURGEBEFORESPEAK << L";"
		L"\n" L"	public static final int SPF_IS_FILENAME = " << SPF_IS_FILENAME << L";"
		L"\n" L"	public static final int SPF_NLP_SPEAK_PUNC = " << SPF_NLP_SPEAK_PUNC << L";"
		L"\n" L"	public static final int SPF_PARSE_SAPI = " << SPF_PARSE_SAPI << L";"
		L"\n" L"	public static final int SPF_PARSE_SSML = " << SPF_PARSE_SSML << L";"
//		L"\n" L"	public static final int  = " << << L";"
		
		L"\n" L"}"
		L"\n";
	return 0;
}

