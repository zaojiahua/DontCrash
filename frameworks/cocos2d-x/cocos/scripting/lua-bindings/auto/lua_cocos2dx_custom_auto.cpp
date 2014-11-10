#include "lua_cocos2dx_custom_auto.hpp"
#include "custom/WeixinShare.h"
#include "custom/WapsAd.h"
#include "tolua_fix.h"
#include "LuaBasicConversions.h"



int lua_cocos2dx_custom_WeixinShare_sendToFriend(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"WeixinShare",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 0)
    {
        if(!ok)
            return 0;
        WeixinShare::sendToFriend();
        return 0;
    }
    CCLOG("%s has wrong number of arguments: %d, was expecting %d\n ", "sendToFriend",argc, 0);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cocos2dx_custom_WeixinShare_sendToFriend'.",&tolua_err);
#endif
    return 0;
}
int lua_cocos2dx_custom_WeixinShare_sendToTimeLine(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"WeixinShare",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 0)
    {
        if(!ok)
            return 0;
        WeixinShare::sendToTimeLine();
        return 0;
    }
    CCLOG("%s has wrong number of arguments: %d, was expecting %d\n ", "sendToTimeLine",argc, 0);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cocos2dx_custom_WeixinShare_sendToTimeLine'.",&tolua_err);
#endif
    return 0;
}
static int lua_cocos2dx_custom_WeixinShare_finalize(lua_State* tolua_S)
{
    printf("luabindings: finalizing LUA object (WeixinShare)");
    return 0;
}

int lua_register_cocos2dx_custom_WeixinShare(lua_State* tolua_S)
{
    tolua_usertype(tolua_S,"WeixinShare");
    tolua_cclass(tolua_S,"WeixinShare","WeixinShare","",nullptr);

    tolua_beginmodule(tolua_S,"WeixinShare");
        tolua_function(tolua_S,"sendToFriend", lua_cocos2dx_custom_WeixinShare_sendToFriend);
        tolua_function(tolua_S,"sendToTimeLine", lua_cocos2dx_custom_WeixinShare_sendToTimeLine);
    tolua_endmodule(tolua_S);
    std::string typeName = typeid(WeixinShare).name();
    g_luaType[typeName] = "WeixinShare";
    g_typeCast["WeixinShare"] = "WeixinShare";
    return 1;
}

int lua_cocos2dx_custom_WapsAd_showAd(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"WapsAd",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 1)
    {
        int arg0;
        ok &= luaval_to_int32(tolua_S, 2,(int *)&arg0);
        if(!ok)
            return 0;
        WapsAd::showAd(arg0);
        return 0;
    }
    CCLOG("%s has wrong number of arguments: %d, was expecting %d\n ", "showAd",argc, 1);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cocos2dx_custom_WapsAd_showAd'.",&tolua_err);
#endif
    return 0;
}
int lua_cocos2dx_custom_WapsAd_constructor(lua_State* tolua_S)
{
    int argc = 0;
    WapsAd* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif



    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
            return 0;
        cobj = new WapsAd();
        tolua_pushusertype(tolua_S,(void*)cobj,"WapsAd");
        tolua_register_gc(tolua_S,lua_gettop(tolua_S));
        return 1;
    }
    CCLOG("%s has wrong number of arguments: %d, was expecting %d \n", "WapsAd",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_error(tolua_S,"#ferror in function 'lua_cocos2dx_custom_WapsAd_constructor'.",&tolua_err);
#endif

    return 0;
}

static int lua_cocos2dx_custom_WapsAd_finalize(lua_State* tolua_S)
{
    printf("luabindings: finalizing LUA object (WapsAd)");
    return 0;
}

int lua_register_cocos2dx_custom_WapsAd(lua_State* tolua_S)
{
    tolua_usertype(tolua_S,"WapsAd");
    tolua_cclass(tolua_S,"WapsAd","WapsAd","",nullptr);

    tolua_beginmodule(tolua_S,"WapsAd");
        tolua_function(tolua_S,"new",lua_cocos2dx_custom_WapsAd_constructor);
        tolua_function(tolua_S,"showAd", lua_cocos2dx_custom_WapsAd_showAd);
    tolua_endmodule(tolua_S);
    std::string typeName = typeid(WapsAd).name();
    g_luaType[typeName] = "WapsAd";
    g_typeCast["WapsAd"] = "WapsAd";
    return 1;
}
TOLUA_API int register_all_cocos2dx_custom(lua_State* tolua_S)
{
	tolua_open(tolua_S);
	
	tolua_module(tolua_S,"cc",0);
	tolua_beginmodule(tolua_S,"cc");

	lua_register_cocos2dx_custom_WeixinShare(tolua_S);
	lua_register_cocos2dx_custom_WapsAd(tolua_S);

	tolua_endmodule(tolua_S);
	return 1;
}

