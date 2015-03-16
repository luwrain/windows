// SAPIImpl.cpp : Defines the exported functions for the DLL application.

#include "stdafx.h"

#include <sapi.h>
#pragma warning (disable:4996) 
#include <sphelper.h>

#include "org_luwrain_windows_speech_SAPIImpl.h"

// классы помошники
// автоматически очищяет память указанного объекта, созданного с помощью new
class Autocleaner{ public: void* resource; Autocleaner(void* to_clean){ resource = to_clean; }; ~Autocleaner(){ delete resource; } };
class CoAutocleaner{ public: void* resource; CoAutocleaner(void* to_clean){ resource = to_clean; }; ~CoAutocleaner(){ CoTaskMemFree(resource); } };

// заворачиваем весь функционал в класс, только для синтаксического удобства организации кода
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
		// todo: корректная обработка ошибок иннициализации
		hr = ::CoInitialize(NULL);
		//
		hr = CoCreateInstance(CLSID_SpVoice, NULL, CLSCTX_ALL, IID_ISpVoice, (void **)&cpVoice);
		//hr = SpCreateBestObject(SPCAT_VOICES, NULL, NULL, &cpVoice);
	}
	jint searchVoiceToken(jchar* cond)
	{
//		MessageBox(NULL,(LPWSTR)cond,L"debug",MB_OK);
		hr = SpEnumTokens(SPCAT_VOICES, (WCHAR*)cond, NULL, &cpIEnum);
		if (hr != S_OK) return -1; // если ошибка, вернем количество - 0 todo: добавить обработку ошибок
		// определяем количество
		jint cnt = 0;
		hr = cpIEnum->GetCount((ULONG*)&cnt);
		if (hr != S_OK) return -1; // если ошибка, вернем количество - 0 todo: добавить обработку ошибок
		return cnt;
	}
	jint selectVoiceById(jchar* id)
	{
		// чистим предыдущий токен, если был
		if (cpToken != NULL) { cpToken.Release(); cpToken = NULL; }
		// выбираем токен по id
		hr = SpGetTokenFromId((WCHAR*)id,&cpToken);
		if (hr != S_OK) return false;
		// устанавливаем его как текущий голос
		hr = cpVoice->SetVoice(cpToken);
		if (hr != S_OK) return false;
		return true;
	}
	jint selectCurrentVoice()
	{
		// устанавливаем текущий голос
		hr = cpVoice->SetVoice(cpToken);
		if (hr != S_OK) return false;
		return true;
	}
	void setIdStringFromVoiceListNext(LPWSTR* id)
	{
		// чистим предыдущий токен, если был
		if (cpToken != NULL) { cpToken.Release(); cpToken = NULL; }
		// получаем следующий
		hr = cpIEnum->Next(1, &cpToken, NULL);
		if (hr != S_OK) return;
		// получаем идентификатор токена (тут выделяется память под струку)
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
	new CoAutocleaner(id); // чуть раньше времени задаем метод автоочистки памяти
	impl.setIdStringFromVoiceListNext(&id);
	if (id == NULL) return NULL;
	// формируем строку для возврата в java
	return jni->NewString((jchar*)id, (jsize)wcslen(id));
}
JNIEXPORT jint JNICALL Java_org_luwrain_windows_speech_SAPIImpl_selectCurrentVoice(JNIEnv * jni, jclass jthis)
{
	impl.init();
	//
	// выбираем текущий токен
	return impl.selectCurrentVoice();
}
JNIEXPORT jint JNICALL Java_org_luwrain_windows_speech_SAPIImpl_selectVoiceById(JNIEnv * jni, jclass jthis, jstring jtext)
{
	impl.init();
	//
	// выгружаем строку с условием
	jsize length = jni->GetStringLength(jtext);
	jchar* text = new jchar[length + 1];
	new Autocleaner(text);
	jni->GetStringRegion(jtext, 0, length, text);
	text[length] = L'\x0';
	// выбираем токен по идентификатору
	return impl.selectVoiceById(text);
}
JNIEXPORT jint JNICALL Java_org_luwrain_windows_speech_SAPIImpl_searchVoiceByAttributes(JNIEnv * jni, jclass jthis, jstring jtext)
{
	impl.init();
	//
	// если критерии не указаны (выдан null) то делаем запрос на все токены
	if (jtext == NULL) return impl.searchVoiceToken(NULL);
	// выгружаем строку с условием
	jsize length = jni->GetStringLength(jtext);
	jchar* text = new jchar[length + 1];
	new Autocleaner(text);
	jni->GetStringRegion(jtext, 0, length, text);
	text[length] = L'\x0';
	// запрос на токены по критериям
	return impl.searchVoiceToken(text);
}
JNIEXPORT jint JNICALL Java_org_luwrain_windows_speech_SAPIImpl_speak(JNIEnv * jni, jclass jthis, jstring jtext)
{
	impl.init();
	// выгружаем строку с условием
	jsize length = jni->GetStringLength(jtext);
	jchar* text = new jchar[length + 1];
	new Autocleaner(text);
	jni->GetStringRegion(jtext, 0, length, text);
	text[length] = L'\x0';
	// говорим
	return impl.speak(text);
}
