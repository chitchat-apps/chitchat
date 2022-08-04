export type PromiseStatus = "pending" | "success" | "error";

export type PromiseResult<T> = {
  status: PromiseStatus;
  response: T;
};

export const wrapPromise = <T>(promise: Promise<T>): { read: () => T } => {
  let status: PromiseStatus = "pending";
  let response: T;

  const suspender = promise.then(
    (res) => {
      status = "success";
      response = res;
    },
    (err) => {
      status = "error";
      response = err;
    }
  );

  const read = () => {
    switch (status) {
      case "pending":
        throw suspender;
      case "success":
        return response;
      case "error":
        throw response;
    }
  };

  return { read };
};
