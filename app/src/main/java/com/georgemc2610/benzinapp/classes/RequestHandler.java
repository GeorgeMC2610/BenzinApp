package com.georgemc2610.benzinapp.classes;

public class RequestHandler
{
    private static RequestHandler instance;

    private String token;

    private RequestHandler()
    {
    }

    public static RequestHandler getInstance() { return instance; }
    
    public static void Create()
    {
        instance = new RequestHandler();
    }

}
