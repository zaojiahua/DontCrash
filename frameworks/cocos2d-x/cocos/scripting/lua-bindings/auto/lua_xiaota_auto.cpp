#include "lua_xiaota_auto.hpp"
#include "CircleBy.h"
#include "tolua_fix.h"
#include "LuaBasicConversions.h"



int lua_xiaota_CircleBy_startWithTarget(lua_State* tolua_S)
{
    int argc = 0;
    CircleBy* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"CircleBy",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (CircleBy*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_xiaota_CircleBy_startWithTarget'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        cocos2d::Node* arg0;

        ok &= luaval_to_object<cocos2d::Node>(tolua_S, 2, "cc.Node",&arg0);
        if(!ok)
            return 0;
        cobj->startWithTarget(arg0);
        return 0;
    }
    CCLOG("%s has wrong number of arguments: %d, was expecting %d \n", "startWithTarget",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_xiaota_CircleBy_startWithTarget'.",&tolua_err);
#endif

    return 0;
}
int lua_xiaota_CircleBy_init(lua_State* tolua_S)
{
    int argc = 0;
    CircleBy* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"CircleBy",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (CircleBy*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_xiaota_CircleBy_init'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 3) 
    {
        double arg0;
        cocos2d::Point arg1;
        double arg2;

        ok &= luaval_to_number(tolua_S, 2,&arg0);

        ok &= luaval_to_point(tolua_S, 3, &arg1);

        ok &= luaval_to_number(tolua_S, 4,&arg2);
        if(!ok)
            return 0;
        bool ret = cobj->init(arg0, arg1, arg2);
        tolua_pushboolean(tolua_S,(bool)ret);
        return 1;
    }
    CCLOG("%s has wrong number of arguments: %d, was expecting %d \n", "init",argc, 3);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_xiaota_CircleBy_init'.",&tolua_err);
#endif

    return 0;
}
int lua_xiaota_CircleBy_clone(lua_State* tolua_S)
{
    int argc = 0;
    CircleBy* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"CircleBy",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (CircleBy*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_xiaota_CircleBy_clone'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
            return 0;
        CircleBy* ret = cobj->clone();
        object_to_luaval<CircleBy>(tolua_S, "CircleBy",(CircleBy*)ret);
        return 1;
    }
    CCLOG("%s has wrong number of arguments: %d, was expecting %d \n", "clone",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_xiaota_CircleBy_clone'.",&tolua_err);
#endif

    return 0;
}
int lua_xiaota_CircleBy_update(lua_State* tolua_S)
{
    int argc = 0;
    CircleBy* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"CircleBy",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (CircleBy*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_xiaota_CircleBy_update'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        double arg0;

        ok &= luaval_to_number(tolua_S, 2,&arg0);
        if(!ok)
            return 0;
        cobj->update(arg0);
        return 0;
    }
    CCLOG("%s has wrong number of arguments: %d, was expecting %d \n", "update",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_xiaota_CircleBy_update'.",&tolua_err);
#endif

    return 0;
}
int lua_xiaota_CircleBy_reverse(lua_State* tolua_S)
{
    int argc = 0;
    CircleBy* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"CircleBy",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (CircleBy*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_xiaota_CircleBy_reverse'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
            return 0;
        CircleBy* ret = cobj->reverse();
        object_to_luaval<CircleBy>(tolua_S, "CircleBy",(CircleBy*)ret);
        return 1;
    }
    CCLOG("%s has wrong number of arguments: %d, was expecting %d \n", "reverse",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_xiaota_CircleBy_reverse'.",&tolua_err);
#endif

    return 0;
}
int lua_xiaota_CircleBy_create(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"CircleBy",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 3)
    {
        double arg0;
        cocos2d::Point arg1;
        double arg2;
        ok &= luaval_to_number(tolua_S, 2,&arg0);
        ok &= luaval_to_point(tolua_S, 3, &arg1);
        ok &= luaval_to_number(tolua_S, 4,&arg2);
        if(!ok)
            return 0;
        CircleBy* ret = CircleBy::create(arg0, arg1, arg2);
        object_to_luaval<CircleBy>(tolua_S, "CircleBy",(CircleBy*)ret);
        return 1;
    }
    CCLOG("%s has wrong number of arguments: %d, was expecting %d\n ", "create",argc, 3);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_xiaota_CircleBy_create'.",&tolua_err);
#endif
    return 0;
}
static int lua_xiaota_CircleBy_finalize(lua_State* tolua_S)
{
    printf("luabindings: finalizing LUA object (CircleBy)");
    return 0;
}

int lua_register_xiaota_CircleBy(lua_State* tolua_S)
{
    tolua_usertype(tolua_S,"CircleBy");
    tolua_cclass(tolua_S,"CircleBy","CircleBy","cc.ActionInterval",nullptr);

    tolua_beginmodule(tolua_S,"CircleBy");
        tolua_function(tolua_S,"startWithTarget",lua_xiaota_CircleBy_startWithTarget);
        tolua_function(tolua_S,"init",lua_xiaota_CircleBy_init);
        tolua_function(tolua_S,"clone",lua_xiaota_CircleBy_clone);
        tolua_function(tolua_S,"update",lua_xiaota_CircleBy_update);
        tolua_function(tolua_S,"reverse",lua_xiaota_CircleBy_reverse);
        tolua_function(tolua_S,"create", lua_xiaota_CircleBy_create);
    tolua_endmodule(tolua_S);
    std::string typeName = typeid(CircleBy).name();
    g_luaType[typeName] = "CircleBy";
    g_typeCast["CircleBy"] = "CircleBy";
    return 1;
}
TOLUA_API int register_all_xiaota(lua_State* tolua_S)
{
	tolua_open(tolua_S);
	
	tolua_module(tolua_S,"tt",0);
	tolua_beginmodule(tolua_S,"tt");

	lua_register_xiaota_CircleBy(tolua_S);

	tolua_endmodule(tolua_S);
	return 1;
}

