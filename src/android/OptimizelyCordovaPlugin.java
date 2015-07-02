package com.optimizely.cordova;

import android.text.TextUtils;
import android.util.Log;

import org.apache.cordova.*;
import org.json.JSONObject;
import org.json.JSONArray;
import org.json.JSONException;

import com.optimizely.Optimizely;
import com.optimizely.Variable.LiveVariable;
import com.optimizely.CodeBlocks.CodeBranch;
import com.optimizely.CodeBlocks.DefaultCodeBranch;
import com.optimizely.CodeBlocks.OptimizelyCodeBlock;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Set;

public class OptimizelyCordovaPlugin extends CordovaPlugin {
    private static HashMap<String, LiveVariable> liveVariables;
    private static HashMap<String, OptimizelyCodeBlock> codeBlocks;

    @Override
    public boolean execute(String action, JSONArray data, final CallbackContext callbackContext) throws JSONException {

        if (action.equals("booleanVariable")) {
            String variableKey = data.getString(0);
            boolean variableValue = data.getBoolean(1);
            booleanVariable(variableKey, variableValue, callbackContext);
            return true;
        } else if (action.equals("codeBlock")) {
            String codeBlockKey = data.getString(0);
            JSONArray codeBlockBranchNamesJSON = data.getJSONArray(1);
            ArrayList<String> codeBlockBranchNames = new ArrayList();
            for (int i = 0; i < codeBlockBranchNamesJSON.length(); i++) {
              String branchName = codeBlockBranchNamesJSON.get(i).toString();
              codeBlockBranchNames.add(branchName);
            }
            codeBlock(codeBlockKey, codeBlockBranchNames, callbackContext);
            return true;
        } else if (action.equals("enableEditor")) {
            enableEditor(callbackContext);
            return true;
        } else if (action.equals("executeCodeBlock")) {
            String codeBlockKey = data.getString(0);
            executeCodeBlock(codeBlockKey, callbackContext);
            return true;
        } else if (action.equals("startOptimizely")) {
            String token = data.getString(0);
            startOptimizely(token, callbackContext);
            return true;
        } else if (action.equals("stringVariable")) {
            String variableKey = data.getString(0);
            String variableValue = data.getString(1);
            stringVariable(variableKey, variableValue, callbackContext);
            return true;
        } else if (action.equals("variableForKey")) {
            String variableKey = data.getString(0);
            variableForKey(variableKey, callbackContext);
            return true;
        }

        return false;
    }

    private boolean enableEditor(final CallbackContext callbackContext) {
      cordova.getActivity().runOnUiThread(new Runnable() {
        public void run() {
          try {
            Optimizely.enableEditor();
            // right now we do not support visual editing
            Optimizely.setVisualExperimentsEnabled(false);
            callbackContext.success();
          } catch (Exception e) {
            callbackContext.error(e.getMessage());
          }
        }
      });
      return true;
    }

    private boolean startOptimizely(final String socketToken, final CallbackContext callbackContext) {
      cordova.getActivity().runOnUiThread(new Runnable() {
        public void run() {
          Optimizely.startOptimizely(socketToken, cordova.getActivity().getApplication());
          callbackContext.success("Optimizely Started!");
        }
      });
      return true;
    }

    private boolean stringVariable(final String variableKey, final String variableValue,
      final CallbackContext callbackContext) {
      cordova.getActivity().runOnUiThread(new Runnable() {
        public void run() {
          try {
            if (liveVariables == null) {
              liveVariables = new HashMap();
            }

            liveVariables.put(variableKey, Optimizely.stringVariable(variableKey, variableValue));
            callbackContext.success();
          } catch (Exception e) {
            callbackContext.error("Unable to register live variable: " + e.getMessage());
          }
        }
      });
      return true;
    }

    private boolean booleanVariable(final String variableKey, final boolean variableValue,
      final CallbackContext callbackContext) {
      cordova.getActivity().runOnUiThread(new Runnable() {
        public void run() {
          try {
            if (liveVariables == null) {
              liveVariables = new HashMap();
            }

            liveVariables.put(variableKey, Optimizely.booleanVariable(variableKey, variableValue));
            callbackContext.success();
          } catch (Exception e) {
            callbackContext.error("Unable to register live variable: " + e.getMessage());
          }
        }
      });
      return true;
    }

    private boolean variableForKey(final String variableKey, final CallbackContext callbackContext) {
      cordova.getActivity().runOnUiThread(new Runnable() {
        public void run() {
          if (liveVariables.containsKey(variableKey)) {
            LiveVariable liveVariable = liveVariables.get(variableKey);

            try {
              // construct the JSON object for the variable
              JSONObject variableValue = new JSONObject();
              variableValue.put("variableKey", variableKey);
              variableValue.put("variableValue", liveVariable.get());
              callbackContext.success(variableValue);
            } catch (JSONException ex) {
              callbackContext.error(ex.getMessage());
            }
          } else {
            callbackContext.error("Variable for key: " + variableKey + " does not exist.");
          }
        }
      });
      return true;
    }

    private boolean codeBlock(final String codeBlockKey, final ArrayList<String> branches, final CallbackContext callbackContext) {
      cordova.getActivity().runOnUiThread(new Runnable() {
        public void run() {
          if (codeBlocks == null) {
            codeBlocks = new HashMap();
          }
          codeBlocks.put(codeBlockKey, Optimizely.codeBlock(codeBlockKey)
            .withBranchNames(branches.toArray(new String[branches.size()])));
          callbackContext.success();
        }
      });
      return true;
    }

    private boolean executeCodeBlock(final String codeBlockKey, final CallbackContext callbackContext) {
      cordova.getActivity().runOnUiThread(new Runnable() {
        public void run() {
          if (codeBlocks.containsKey(codeBlockKey)) {
            OptimizelyCodeBlock codeBlock = codeBlocks.get(codeBlockKey);
            ArrayList<CodeBranch> codeBranches = new ArrayList();
            Set<String> branchNames = codeBlock.getBranchNames();
            for (int i = 1; i < branchNames.size(); i++) {
                final String branchIndex = String.valueOf(i);
                codeBranches.add(new CodeBranch() {
                    @Override
                    public void execute() {
                      callbackContext.success(branchIndex);
                    }
                });
            }

            CodeBranch[] codeBranchesArray = codeBranches.toArray(new CodeBranch[codeBranches.size()]);
            codeBlock.execute(new DefaultCodeBranch() {
              @Override
              public void execute() {
                callbackContext.success("0");
              }
            }, codeBranchesArray);
          } else {
            callbackContext.error("Codeblock for key: " + codeBlockKey + " does not exist.");
          }
        }
      });
      return true;
    }
}
