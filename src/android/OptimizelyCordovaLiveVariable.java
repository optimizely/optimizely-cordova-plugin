package com.optimizely.cordova;

/**
 * Created by mng on 3/19/16.
 */
import android.graphics.Color;

import com.optimizely.Optimizely;
import com.optimizely.Variable.LiveVariable;
import com.optimizely.cordova.exceptions.InvalidVariableTypeException;

import org.json.JSONArray;
import org.json.JSONException;

public class OptimizelyCordovaLiveVariable {

    private LiveVariable liveVariable;

    private int variableType;

    public static final int BOOLEAN = 1;

    public static final int COLOR = 2;

    public static final int NUMBER = 3;

    public static final int STRING = 4;

    public OptimizelyCordovaLiveVariable(LiveVariable liveVariable, int variableType) {
        this.liveVariable = liveVariable;
        this.variableType = variableType;
    }

    public Object getValue() {
        Object value = this.liveVariable.get();
        if (this.variableType == COLOR) {
            int colorIntValue = (Integer)value;
            String hexColor = String.format("#%06X", (0xFFFFFF & colorIntValue));
            return hexColor;
        }

        return value;
    }

    public static OptimizelyCordovaLiveVariable fromJSON(JSONArray variableData, int variableType) throws InvalidVariableTypeException, JSONException{
        String variableKey = variableData.getString(0);
        LiveVariable liveVariable;

        switch (variableType) {
            case BOOLEAN:
                boolean booleanValue = variableData.getBoolean(1);
                liveVariable = Optimizely.booleanVariable(variableKey, booleanValue);
                break;
            case COLOR:
                String hexValue = variableData.getString(1);
                liveVariable = Optimizely.colorVariable(variableKey, Color.parseColor(hexValue));
                break;
            case NUMBER:
                float numberValue= (float)variableData.getDouble(1);
                liveVariable = Optimizely.floatVariable(variableKey, numberValue);
                break;
            case STRING:
                String stringValue = variableData.getString(1);
                liveVariable = Optimizely.stringVariable(variableKey, stringValue);
                break;
            default:
                throw new InvalidVariableTypeException();
        }

        return new OptimizelyCordovaLiveVariable(liveVariable, variableType);
    }
}
