// SAPIImpl.cpp : Defines the exported functions for the DLL application.

#include "stdafx.h"

#include <sapi.h>
#pragma warning (disable:4996) 
#include <sphelper.h>

#include "org_luwrain_windows_speech_SAPIImpl.h"

// ������ ���������
// ������������� ������� ������ ���������� �������, ���������� � ������� new
class Autocleaner{ public: void* resource; Autocleaner(void* to_clean){ resource = to_clean; }; ~Autocleaner(){ delete resource; } };
class CoAutocleaner{ public: void* resource; CoAutocleaner(void* to_clean){ resource = to_clean; }; ~CoAutocleaner(){ CoTaskMemFree(resource); } };

// ������������ ���� ���������� � �����, ������ ��� ��������������� �������� ����������� ����
class SAPIImpl
{
public:
	bool skipInit = false;
	CComPtr<IEnumSpObjectTokens> cpIEnum;
	CComPtr<ISpObjectToken> cpToken = NULL;
	CComPtr<ISpVoice> cpVoice;
	HRESULT hr;

	void init()
	{
		if (skipInit) return;
		skipInit = true;
		// todo: ���������� ��������� ������ ��������������
		hr = ::CoInitialize(NULL);
		//
		hr = CoCreateInstance(CLSID_SpVoice, NULL, CLSCTX_ALL, IID_ISpVoice, (void **)&cpVoice);
		//hr = SpCreateBestObject(SPCAT_VOICES, NULL, NULL, &cpVoice);
	}
	jint searchVoiceToken(jchar* cond)
	{
//		MessageBox(NULL,(LPWSTR)cond,L"debug",MB_OK);
		hr = SpEnumTokens(SPCAT_VOICES, (WCHAR*)cond, NULL, &cpIEnum);
		if (hr != S_OK) return -1; // ���� ������, ������ ���������� - 0 todo: �������� ��������� ������
		// ���������� ����������
		jint cnt = 0;
		hr = cpIEnum->GetCount((ULONG*)&cnt);
		if (hr != S_OK) return -1; // ���� ������, ������ ���������� - 0 todo: �������� ��������� ������
		return cnt;
	}
	jint selectVoiceById(jchar* id)
	{
		// ������ ���������� �����, ���� ���
		if (cpToken != NULL) { cpToken.Release(); cpToken = NULL; }
		// �������� ����� �� id
		hr = SpGetTokenFromId((WCHAR*)id,&cpToken);
		if (hr != S_OK) return false;
		// ������������� ��� ��� ������� �����
		hr = cpVoice->SetVoice(cpToken);
		if (hr != S_OK) return false;
		return true;
	}
	jint selectCurrentVoice()
	{
		// ������������� ������� �����
		hr = cpVoice->SetVoice(cpToken);
		if (hr != S_OK) return false;
		return true;
	}
	void setIdStringFromVoiceListNext(LPWSTR* id)
	{
		// ������ ���������� �����, ���� ���
		if (cpToken != NULL) { cpToken.Release(); cpToken = NULL; }
		// �������� ���������
		hr = cpIEnum->Next(1, &cpToken, NULL);
		if (hr != S_OK) return;
		// �������� ������������� ������ (��� ���������� ������ ��� ������)
		hr = cpToken->GetId(id);

	}
	jint speak(jchar* text)
	{
		hr = cpVoice->Speak((LPWSTR)text, 0, NULL);
		if (hr != S_OK) return false;
		return true;
	}

};

SAPIImpl impl;

JNIEXPORT jstring JNICALL Java_org_luwrain_windows_speech_SAPIImpl_getNextVoiceIdFromList(JNIEnv * jni, jclass jthis)
{
	impl.init();
	//
	LPWSTR id = NULL;
	new CoAutocleaner(id); // ���� ������ ������� ������ ����� ����������� ������
	impl.setIdStringFromVoiceListNext(&id);
	if (id == NULL) return NULL;
	// ��������� ������ ��� �������� � java
	return jni->NewString((jchar*)id, (jsize)wcslen(id));
}
JNIEXPORT jint JNICALL Java_org_luwrain_windows_speech_SAPIImpl_selectCurrentVoice(JNIEnv * jni, jclass jthis)
{
	impl.init();
	//
	// �������� ������� �����
	return impl.selectCurrentVoice();
}
JNIEXPORT jint JNICALL Java_org_luwrain_windows_speech_SAPIImpl_selectVoiceById(JNIEnv * jni, jclass jthis, jstring jtext)
{
	impl.init();
	//
	// ��������� ������ � ��������
	jsize length = jni->GetStringLength(jtext);
	jchar* text = new jchar[length + 1];
	new Autocleaner(text);
	jni->GetStringRegion(jtext, 0, length, text);
	text[length] = L'\x0';
	// �������� ����� �� ��������������
	return impl.selectVoiceById(text);
}
JNIEXPORT jint JNICALL Java_org_luwrain_windows_speech_SAPIImpl_searchVoiceByAttributes(JNIEnv * jni, jclass jthis, jstring jtext)
{
	impl.init();
	//
	// ���� �������� �� ������� (����� null) �� ������ ������ �� ��� ������
	if (jtext == NULL) return impl.searchVoiceToken(NULL);
	// ��������� ������ � ��������
	jsize length = jni->GetStringLength(jtext);
	jchar* text = new jchar[length + 1];
	new Autocleaner(text);
	jni->GetStringRegion(jtext, 0, length, text);
	text[length] = L'\x0';
	// ������ �� ������ �� ���������
	return impl.searchVoiceToken(text);
}
JNIEXPORT jint JNICALL Java_org_luwrain_windows_speech_SAPIImpl_speak(JNIEnv * jni, jclass jthis, jstring jtext)
{
	impl.init();
	// ��������� ������ � ��������
	jsize length = jni->GetStringLength(jtext);
	jchar* text = new jchar[length + 1];
	new Autocleaner(text);
	jni->GetStringRegion(jtext, 0, length, text);
	text[length] = L'\x0';
	// �������
	return impl.speak(text);
}
